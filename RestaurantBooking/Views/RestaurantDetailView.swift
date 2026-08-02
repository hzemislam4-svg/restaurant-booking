//
//  RestaurantDetailView.swift
//  RestaurantBooking
//

import SwiftUI
import MapKit

struct RestaurantDetailView: View {
    @EnvironmentObject private var store: AppStore
    let restaurant: Restaurant
    @State private var showBookingSheet = false

    @State private var cameraPosition: MapCameraPosition

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        _cameraPosition = State(initialValue: .region(
            MKCoordinateRegion(
                center: restaurant.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        ))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                heroHeader

                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    titleBlock
                    highlightsSection
                    aboutSection
                    hoursSection
                    mapSection
                }
                .padding(AppSpacing.md)
            }
        }
        .background(AppColor.background)
        .ignoresSafeArea(edges: .top)
        .safeAreaInset(edge: .bottom) {
            bookButton
        }
        .sheet(isPresented: $showBookingSheet) {
            BookingView(restaurant: restaurant)
        }
    }

    private var heroHeader: some View {
        ZStack(alignment: .topTrailing) {
            RestaurantPhotoView(restaurant: restaurant, cornerRadius: 0)
                .frame(height: 260)

            Button {
                store.toggleFavorite(restaurant)
            } label: {
                Image(systemName: store.isFavorite(restaurant) ? "heart.fill" : "heart")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(store.isFavorite(restaurant) ? AppColor.danger : .white)
                    .padding(12)
                    .background(.black.opacity(0.35), in: Circle())
            }
            .padding(.top, 56)
            .padding(.trailing, AppSpacing.md)
        }
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(restaurant.name)
                .font(.displayTitle)
                .foregroundStyle(AppColor.textPrimary)

            HStack(spacing: 8) {
                RatingBadge(rating: restaurant.rating, reviewCount: restaurant.reviewCount)
                Text("· \(restaurant.priceTier.symbol)")
                    .foregroundStyle(AppColor.textSecondary)
                Text("· \(restaurant.cuisine.icon) \(restaurant.cuisine.arabicName)")
                    .foregroundStyle(AppColor.textSecondary)
            }
            .font(.subheadline)

            Label(restaurant.address, systemImage: "mappin.and.ellipse")
                .font(.footnote)
                .foregroundStyle(AppColor.textSecondary)
        }
    }

    private var highlightsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("أبرز المميزات")
                .font(.sectionTitle)

            FlowLayout(spacing: 8) {
                ForEach(restaurant.highlights, id: \.self) { highlight in
                    Text(highlight)
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColor.accentSoft)
                        .foregroundStyle(AppColor.accent)
                        .clipShape(Capsule())
                }
            }
        }
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("عن المطعم")
                .font(.sectionTitle)
            Text(restaurant.description)
                .font(.bodyText)
                .foregroundStyle(AppColor.textSecondary)
        }
    }

    private var hoursSection: some View {
        HStack {
            Label("مفتوح يومياً", systemImage: "clock")
                .font(.subheadline)
                .foregroundStyle(AppColor.textPrimary)
            Spacer()
            Text("\(restaurant.openingTime) – \(restaurant.closingTime)")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppColor.textSecondary)
        }
        .padding(AppSpacing.md)
        .background(AppColor.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
    }

    private var mapSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("الموقع")
                .font(.sectionTitle)

            Map(position: $cameraPosition) {
                Marker(restaurant.name, coordinate: restaurant.coordinate)
                    .tint(AppColor.accent)
            }
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
            .disabled(true) // معاينة فقط؛ اضغط "الاتجاهات" لفتح خرائط Apple
            .overlay(alignment: .bottomTrailing) {
                Button {
                    openInMaps()
                } label: {
                    Label("الاتجاهات", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.white)
                        .clipShape(Capsule())
                        .shadow(radius: 3)
                }
                .padding(10)
            }
        }
    }

    private var bookButton: some View {
        Button {
            showBookingSheet = true
        } label: {
            Text("احجز طاولة")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColor.accent)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(.ultraThinMaterial)
    }

    private func openInMaps() {
        let placemark = MKPlacemark(coordinate: restaurant.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = restaurant.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

/// Minimal flow layout so highlight chips wrap naturally instead of
/// overflowing off-screen in a single HStack.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var currentRowWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentRowWidth + size.width > maxWidth {
                totalHeight += rowHeight + spacing
                currentRowWidth = size.width + spacing
                rowHeight = size.height
            } else {
                currentRowWidth += size.width + spacing
                rowHeight = max(rowHeight, size.height)
            }
        }
        totalHeight += rowHeight
        return CGSize(width: maxWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    NavigationStack {
        RestaurantDetailView(restaurant: PreviewFixtures.restaurant)
    }
    .environmentObject(AppStore())
    .environmentObject(FirebaseAuthService())
    .environmentObject(ReservationRepository())
}
