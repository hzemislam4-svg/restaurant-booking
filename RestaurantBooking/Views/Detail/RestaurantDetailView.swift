import SwiftUI

struct RestaurantDetailView: View {
    @EnvironmentObject var store: AppStore
    let restaurant: Restaurant

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                topBar
                hero
                gallery
                info
            }
            .padding(.bottom, 40)
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .environment(\.layoutDirection, .rightToLeft)
    }

    private var topBar: some View {
        HStack {
            IconBackButton { store.flow = nil }
            Spacer()
            FavoriteButton(isFavorite: store.isFavorite(restaurant)) {
                store.toggleFavorite(restaurant)
            }
            .foregroundStyle(store.accentColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private var hero: some View {
        FoodPlaceholderImage(title: "صورة المطعم")
            .frame(height: 190)
    }

    private var gallery: some View {
        HStack(spacing: 6) {
            FoodPlaceholderImage()
                .frame(height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            FoodPlaceholderImage()
                .frame(height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            FoodPlaceholderImage()
                .frame(height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    private var info: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text(restaurant.name)
                .font(.custom(Theme.fontName, size: 22, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 6)

            HStack(spacing: 6) {
                TagView(text: restaurant.cuisine, outlined: true)
                TagView(text: restaurant.price)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.bottom, 8)

            Text("\(restaurant.area) · \(restaurant.distance)")
                .font(.custom(Theme.fontName, size: 12))
                .foregroundStyle(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .trailing)

            HStack(spacing: 4) {
                StarRatingView(rating: restaurant.rating)
                Text("(\(restaurant.reviewCount) تقييم)")
                    .font(.custom(Theme.fontName, size: 12))
                    .foregroundStyle(Theme.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.bottom, 14)

            Divider().overlay(Theme.divider)

            HStack(spacing: 6) {
                Image(systemName: "clock")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.textSecondary)
                Text(restaurant.hours)
                    .font(.custom(Theme.fontName, size: 12.5))
                    .foregroundStyle(Theme.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.vertical, 14)

            Text(restaurant.description)
                .font(.custom(Theme.fontName, size: 13))
                .foregroundStyle(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 16)

            PrimaryButton(title: "احجز مقعد", accentColor: store.accentColor) {
                store.flow = .booking(restaurant)
            }

            Divider().overlay(Theme.divider).padding(.vertical, 20)

            HStack {
                Text("التقييمات")
                    .font(.custom(Theme.fontName, size: 17, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                StarRatingView(rating: restaurant.rating)
            }
            .padding(.bottom, 10)

            ForEach(MockData.reviews) { review in
                ReviewCard(review: review)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .trailing, spacing: 6) {
            HStack(spacing: 8) {
                Text(review.initial)
                    .font(.custom(Theme.fontName, size: 13, weight: .bold))
                    .foregroundStyle(Theme.accent)
                    .frame(width: 30, height: 30)
                    .background(Theme.accent.opacity(0.15))
                    .clipShape(Circle())
                VStack(alignment: .trailing, spacing: 2) {
                    Text(review.name)
                        .font(.custom(Theme.fontName, size: 13))
                        .foregroundStyle(Theme.textPrimary)
                    Text(review.starsStr)
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.amber)
                }
                Spacer()
                Text(review.date)
                    .font(.custom(Theme.fontName, size: 11))
                    .foregroundStyle(Theme.textMuted)
            }
            Text(review.comment)
                .font(.custom(Theme.fontName, size: 12.5))
                .foregroundStyle(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: Theme.radiusMd)
                .fill(Theme.card)
        )
    }
}
