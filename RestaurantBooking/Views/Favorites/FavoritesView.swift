import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        VStack(alignment: .trailing, spacing: 14) {
            Text("المفضلة")
                .font(.custom(Theme.fontName, size: 20, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 4)

            if store.favoritesList.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Text("لم تُضِف أي مطعم إلى المفضلة بعد")
                        .font(.custom(Theme.fontName, size: 13))
                        .foregroundStyle(Theme.textSecondary)
                    PrimaryButton(title: "تصفح المطاعم", accentColor: store.accentColor) {
                        store.tab = .home
                    }
                    .frame(width: 200)
                }
                Spacer()
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(store.favoritesList) { restaurant in
                            FavoriteRow(restaurant: restaurant)
                        }
                    }
                    .padding(.bottom, 110)
                }
                .scrollIndicators(.hidden)
            }
        }
        .padding(.horizontal, 20)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct FavoriteRow: View {
    @EnvironmentObject var store: AppStore
    let restaurant: Restaurant

    var body: some View {
        HStack(spacing: 10) {
            FoodPlaceholderImage(cornerRadius: 6)
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            VStack(alignment: .trailing, spacing: 3) {
                Text(restaurant.name)
                    .font(.custom(Theme.fontName, size: 14, weight: .medium))
                    .foregroundStyle(Theme.textPrimary)
                Text("\(restaurant.cuisine) · \(restaurant.area)")
                    .font(.custom(Theme.fontName, size: 11))
                    .foregroundStyle(Theme.textSecondary)
                StarRatingView(rating: restaurant.rating)
            }
            Spacer()
            Button {
                store.toggleFavorite(restaurant)
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.danger)
                    .padding(4)
            }
            .buttonStyle(.plain)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: Theme.radiusMd)
                .fill(Theme.card)
        )
        .contentShape(RoundedRectangle(cornerRadius: Theme.radiusMd))
        .onTapGesture {
            store.flow = .detail(restaurant)
        }
    }
}
