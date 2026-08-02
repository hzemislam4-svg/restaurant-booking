import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch store.tab {
                case .home:
                    HomeView()
                case .map:
                    MapView()
                case .bookings:
                    MyBookingsView()
                case .favorites:
                    FavoritesView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            FloatingTabBar(selection: $store.tab, accentColor: store.accentColor)
                .padding(.horizontal, 22)
                .padding(.bottom, 18)
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct FloatingTabBar: View {
    @Binding var selection: Screen
    var accentColor: Color = Theme.accent

    private let items: [(Screen, String, String)] = [
        (.home, "الرئيسية", "house.fill"),
        (.map, "الخريطة", "map.fill"),
        (.bookings, "حجوزاتي", "calendar.badge.plus"),
        (.favorites, "المفضلة", "heart.fill"),
    ]

    var body: some View {
        HStack {
            ForEach(items, id: \.0) { item in
                let isSelected = selection == item.0
                Button {
                    selection = item.0
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: item.2)
                            .font(.system(size: 17))
                        Text(item.1)
                            .font(.custom(Theme.fontName, size: 9))
                    }
                    .foregroundStyle(isSelected ? accentColor : Theme.textSecondary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(
                        Capsule().fill(isSelected ? accentColor.opacity(0.18) : .clear)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(9)
        .padding(.horizontal, 6)
        .background(
            Capsule()
                .fill(Theme.tabBarBackground)
                .overlay(Capsule().stroke(Theme.tabBarBorder))
        )
        .shadow(color: .black.opacity(0.5), radius: 24, y: 8)
    }
}
