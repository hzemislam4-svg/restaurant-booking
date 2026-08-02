import SwiftUI
import GoogleMaps
import CoreLocation
import UIKit

struct MapView: View {
    @EnvironmentObject var store: AppStore

    private var hasMapKey: Bool {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as? String else { return false }
        return !key.isEmpty && key != "YOUR_MAPS_API_KEY"
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            if hasMapKey {
                GoogleMapContainer(restaurants: MockData.restaurants,
                                   previewId: store.mapPreviewRestaurant?.id) { restaurant in
                    store.mapPreviewRestaurant = restaurant
                }
                .frame(maxHeight: .infinity)
            } else {
                PlaceholderMapView(previewId: store.mapPreviewRestaurant?.id) { restaurant in
                    store.mapPreviewRestaurant = restaurant
                }
                .frame(maxHeight: .infinity)
            }
            previewCard
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .padding(.bottom, 100)
        }
        .environment(\.layoutDirection, .rightToLeft)
    }

    private var header: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text("خريطة المطاعم")
                .font(.custom(Theme.fontName, size: 20, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
            Text("اضغط على أي علامة لعرض تفاصيلها")
                .font(.custom(Theme.fontName, size: 13))
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 20)
        .padding(.bottom, 14)
    }

    @ViewBuilder
    private var previewCard: some View {
        if let r = store.mapPreviewRestaurant {
            Button {
                store.flow = .detail(r)
            } label: {
                HStack(spacing: 10) {
                    FoodPlaceholderImage(cornerRadius: 6)
                        .frame(width: 56, height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    VStack(alignment: .trailing, spacing: 3) {
                        Text(r.name)
                            .font(.custom(Theme.fontName, size: 14, weight: .medium))
                            .foregroundStyle(Theme.textPrimary)
                        Text("\(r.cuisine) · \(r.distance) · ★ \(r.ratingStr)")
                            .font(.custom(Theme.fontName, size: 11))
                            .foregroundStyle(Theme.textSecondary)
                    }
                    Spacer()
                    Text("التفاصيل")
                        .font(.custom(Theme.fontName, size: 12, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(store.accentColor)
                        )
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: Theme.radiusLg)
                        .fill(Theme.card)
                )
            }
            .buttonStyle(.plain)
        }
    }
}

struct GoogleMapContainer: UIViewRepresentable {
    let restaurants: [Restaurant]
    let previewId: String?
    let onSelect: (Restaurant) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition(latitude: 24.7136, longitude: 46.6753, zoom: 12)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.mapType = .normal
        applyStyle(mapView)
        context.coordinator.updateMarkers(mapView)
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        applyStyle(mapView)
        context.coordinator.updateMarkers(mapView)
        if let id = previewId, let marker = context.coordinator.markers[id] {
            mapView.selectedMarker = marker
        } else {
            mapView.selectedMarker = nil
        }
    }

    private func applyStyle(_ mapView: GMSMapView) {
        mapView.mapStyle = try? GMSMapStyle(jsonString: Self.darkStyleJSON)
    }

    static let darkStyleJSON = """
    [
      { "elementType": "geometry", "stylers": [ { "color": "#161826" } ] },
      { "elementType": "labels.text.fill", "stylers": [ { "color": "#8a92a8" } ] },
      { "elementType": "labels.text.stroke", "stylers": [ { "color": "#161826" } ] },
      { "featureType": "administrative", "elementType": "geometry.stroke", "stylers": [ { "color": "#3a4356" } ] },
      { "featureType": "landscape", "elementType": "geometry", "stylers": [ { "color": "#1c2433" } ] },
      { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#222c3d" } ] },
      { "featureType": "road", "elementType": "geometry", "stylers": [ { "color": "#2a3555" } ] },
      { "featureType": "road", "elementType": "geometry.stroke", "stylers": [ { "color": "#232d40" } ] },
      { "featureType": "road.highway", "elementType": "geometry", "stylers": [ { "color": "#313d53" } ] },
      { "featureType": "transit", "elementType": "geometry", "stylers": [ { "color": "#2a3550" } ] },
      { "featureType": "water", "elementType": "geometry", "stylers": [ { "color": "#0f1420" } ] }
    ]
    """

    final class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapContainer
        var markers: [String: GMSMarker] = [:]

        init(_ parent: GoogleMapContainer) {
            self.parent = parent
        }

        func updateMarkers(_ mapView: GMSMapView) {
            let ids = Array(markers.keys)
            for id in ids {
                markers[id]?.map = nil
                markers[id] = nil
            }
            markers.removeAll()
            for restaurant in parent.restaurants {
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: restaurant.mapLat, longitude: restaurant.mapLng))
                marker.title = restaurant.name
                marker.snippet = restaurant.cuisine
                marker.userData = restaurant
                marker.appearAnimation = .pop
                marker.map = mapView
                markers[restaurant.id] = marker
            }
        }

        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            if let restaurant = marker.userData as? Restaurant {
                parent.onSelect(restaurant)
            }
            return true
        }
    }
}

struct PlaceholderMapView: View {
    let previewId: String?
    let onSelect: (Restaurant) -> Void

    var body: some View {
        ZStack {
            Theme.surface
            Canvas { ctx, size in
                var path = Path()
                let vSpacing: CGFloat = size.height / 5
                let hSpacing: CGFloat = size.width / 5
                for i in 1..<5 {
                    path.move(to: CGPoint(x: 0, y: vSpacing * CGFloat(i)))
                    path.addLine(to: CGPoint(x: size.width, y: vSpacing * CGFloat(i)))
                }
                for i in 1..<5 {
                    path.move(to: CGPoint(x: hSpacing * CGFloat(i), y: 0))
                    path.addLine(to: CGPoint(x: hSpacing * CGFloat(i), y: size.height))
                }
                ctx.stroke(path, with: .color(Theme.textPrimary.opacity(0.07)), lineWidth: 1)

                var roadH = Path()
                roadH.move(to: CGPoint(x: 0, y: size.height * 0.34))
                roadH.addLine(to: CGPoint(x: size.width, y: size.height * 0.34))
                ctx.stroke(roadH, with: .color(Theme.textPrimary.opacity(0.1)), lineWidth: 6)

                var roadV = Path()
                roadV.move(to: CGPoint(x: size.width * 0.63, y: 0))
                roadV.addLine(to: CGPoint(x: size.width * 0.63, y: size.height))
                ctx.stroke(roadV, with: .color(Theme.textPrimary.opacity(0.1)), lineWidth: 6)

                var park = Path(roundedRect: CGRect(x: size.width * 0.2, y: size.height * 0.6, width: size.width * 0.22, height: size.height * 0.18), cornerRadius: 6)
                ctx.fill(park, with: .color(Theme.success.opacity(0.12)))

                var parkV = Path(roundedRect: CGRect(x: size.width * 0.06, y: 0, width: size.width * 0.09, height: size.height), cornerRadius: 0)
                ctx.fill(parkV, with: .color(Theme.accent.opacity(0.07)))
                var parkV2 = Path(roundedRect: CGRect(x: size.width * 0.52, y: 0, width: size.width * 0.16, height: size.height), cornerRadius: 0)
                ctx.fill(parkV2, with: .color(Theme.accent.opacity(0.06)))
            }

            VStack(spacing: 6) {
                Image(systemName: "map")
                    .font(.system(size: 24))
                    .foregroundStyle(Theme.textSecondary)
                Text("خريطة تجريبية")
                    .font(.custom(Theme.fontName, size: 13, weight: .medium))
                    .foregroundStyle(Theme.textPrimary)
                Text("أضف مفتاح Google Maps API في إعدادات المستودع لعرض الخريطة الفعلية")
                    .font(.custom(Theme.fontName, size: 11))
                    .foregroundStyle(Theme.textMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            ForEach(MockData.restaurants) { restaurant in
                Button {
                    onSelect(restaurant)
                } label: {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(restaurant.id == previewId ? Theme.purple : Theme.textPrimary)
                        .background(Circle().fill(Theme.surface))
                }
                .buttonStyle(.plain)
                .position(x: restaurant.mapX / 100 * 360, y: restaurant.mapY / 100 * 420)
            }
        }
        .frame(height: 420)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusLg))
        .overlay(RoundedRectangle(cornerRadius: Theme.radiusLg).stroke(Theme.divider))
        .padding(.horizontal, 20)
    }
}
