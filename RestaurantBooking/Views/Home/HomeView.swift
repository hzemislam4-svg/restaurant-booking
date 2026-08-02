import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header
                cuisineChips
                layoutSegments
                content
            }
            .padding(.bottom, 110)
        }
        .scrollIndicators(.hidden)
        .environment(\.layoutDirection, .rightToLeft)
    }

    private var header: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                colors: [store.accentColor.opacity(0.22), Theme.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 190)

            VStack(alignment: .trailing, spacing: 6) {
                Button {
                    store.flow = .account
                } label: {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 20))
                        .foregroundStyle(Theme.textPrimary)
                        .frame(width: 40, height: 40)
                        .background(Color.black.opacity(0.35))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("حسابي")
                .padding(.top, 8)

                HStack(spacing: 5) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 12))
                    Text("المدينة")
                        .font(.custom(Theme.fontName, size: 11))
                }
                .foregroundStyle(Theme.textSecondary)

                Text("أين تريد أن تأكل اليوم؟")
                    .font(.custom(Theme.fontName, size: 20, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)

                Text("اختر مطعماً واحجز مقعدك خلال ثوانٍ")
                    .font(.custom(Theme.fontName, size: 12))
                    .foregroundStyle(Theme.textSecondary)

                searchField
            }
            .padding(.horizontal, 16)
        }
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14))
                .foregroundStyle(Theme.textSecondary)
            TextField("ابحث عن مطعم أو نوع مطبخ", text: $store.search)
                .font(.custom(Theme.fontName, size: 13))
                .foregroundStyle(Theme.textPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 11)
        .background(
            Capsule().fill(Color.white.opacity(0.1))
        )
    }

    private var cuisineChips: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(MockData.cuisines, id: \.self) { cuisine in
                    ChipView(label: cuisine,
                             selected: store.cuisineFilter == cuisine,
                             accentColor: store.accentColor) {
                        store.cuisineFilter = cuisine
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .scrollIndicators(.hidden)
    }

    private var layoutSegments: some View {
        HStack(spacing: 4) {
            ForEach(HomeLayout.allCases, id: \.self) { layout in
                let selected = store.homeLayout == layout
                Button {
                    store.homeLayout = layout
                } label: {
                    Text(layout.rawValue)
                        .font(.custom(Theme.fontName, size: 13, weight: selected ? .bold : .regular))
                        .foregroundStyle(selected ? Theme.textPrimary : Theme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selected ? Color.white.opacity(0.12) : .clear)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.05))
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private var content: some View {
        switch store.homeLayout {
        case .grid:
            gridContent
        case .list:
            listContent
        case .featured:
            featuredContent
        }
    }

    private var gridContent: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible())], spacing: 12) {
            ForEach(store.filteredRestaurants) { restaurant in
                RestaurantGridCard(restaurant: restaurant)
            }
        }
        .padding(.horizontal, 16)
    }

    private var listContent: some View {
        VStack(spacing: 10) {
            ForEach(store.filteredRestaurants) { restaurant in
                RestaurantListCard(restaurant: restaurant)
            }
        }
        .padding(.horizontal, 16)
    }

    private var featuredContent: some View {
        VStack(spacing: 10) {
            if let first = store.filteredRestaurants.first {
                FeaturedCard(restaurant: first)
            }
            ForEach(Array(store.filteredRestaurants.dropFirst())) { restaurant in
                RestaurantListCard(restaurant: restaurant, compact: true)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct RestaurantGridCard: View {
    @EnvironmentObject var store: AppStore
    let restaurant: Restaurant

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack(alignment: .topTrailing) {
                FoodPlaceholderImage(cornerRadius: 10)
                    .frame(height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                FavoriteButton(isFavorite: store.isFavorite(restaurant)) {
                    store.toggleFavorite(restaurant)
                }
                .padding(6)
            }
            Text(restaurant.name)
                .font(.custom(Theme.fontName, size: 14, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(1)
            Text("\(restaurant.cuisine) · \(restaurant.area)")
                .font(.custom(Theme.fontName, size: 11))
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(1)
            StarRatingView(rating: restaurant.rating)
                .padding(.bottom, 2)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: Theme.radiusLg)
                .fill(Theme.card)
        )
        .contentShape(RoundedRectangle(cornerRadius: Theme.radiusLg))
        .onTapGesture {
            store.flow = .detail(restaurant)
        }
    }
}

struct RestaurantListCard: View {
    @EnvironmentObject var store: AppStore
    let restaurant: Restaurant
    var compact: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            FoodPlaceholderImage(cornerRadius: 14)
                .frame(width: compact ? 56 : 64, height: compact ? 56 : 64)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 3) {
                Text(restaurant.name)
                    .font(.custom(Theme.fontName, size: compact ? 13 : 14, weight: .medium))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
                Text("\(restaurant.cuisine) · \(restaurant.area) · \(restaurant.distance)")
                    .font(.custom(Theme.fontName, size: 11))
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(1)
                HStack(spacing: 6) {
                    StarRatingView(rating: restaurant.rating)
                    if !compact {
                        Text(restaurant.price)
                            .font(.custom(Theme.fontName, size: 11))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
            Spacer(minLength: 0)
            Button {
                store.toggleFavorite(restaurant)
            } label: {
                Image(systemName: store.isFavorite(restaurant) ? "heart.fill" : "heart")
                    .font(.system(size: 16))
                    .foregroundStyle(store.isFavorite(restaurant) ? Theme.danger : store.accentColor)
            }
            .buttonStyle(.plain)
            .padding(4)
        }
        .padding(9)
        .background(
            RoundedRectangle(cornerRadius: Theme.radiusLg)
                .fill(Theme.card)
        )
        .contentShape(RoundedRectangle(cornerRadius: Theme.radiusLg))
        .onTapGesture {
            store.flow = .detail(restaurant)
        }
    }
}

struct FeaturedCard: View {
    @EnvironmentObject var store: AppStore
    let restaurant: Restaurant

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                FoodPlaceholderImage(cornerRadius: 0)
                    .frame(height: 150)
                FavoriteButton(isFavorite: store.isFavorite(restaurant)) {
                    store.toggleFavorite(restaurant)
                }
                .padding(8)
            }
            VStack(alignment: .leading, spacing: 5) {
                TagView(text: "الأعلى تقييماً", accent: true)
                Text(restaurant.name)
                    .font(.custom(Theme.fontName, size: 16, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)
                Text("\(restaurant.cuisine) · \(restaurant.area) · ★ \(restaurant.ratingStr) · \(restaurant.distance)")
                    .font(.custom(Theme.fontName, size: 11))
                    .foregroundStyle(Theme.textSecondary)
            }
            .padding(12)
        }
        .background(
            RoundedRectangle(cornerRadius: Theme.radiusLg)
                .fill(Theme.card)
        )
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusLg))
        .contentShape(RoundedRectangle(cornerRadius: Theme.radiusLg))
        .onTapGesture {
            store.flow = .detail(restaurant)
        }
    }
}
