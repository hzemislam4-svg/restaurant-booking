//
//  RestaurantCard.swift
//  RestaurantBooking
//

import SwiftUI

struct RestaurantCard: View {
    @EnvironmentObject private var store: AppStore
    let restaurant: Restaurant

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            ZStack(alignment: .topTrailing) {
                RestaurantPhotoView(restaurant: restaurant, cornerRadius: AppRadius.lg)
                    .frame(height: 160)
                    .clipped()

                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        store.toggleFavorite(restaurant)
                    }
                } label: {
                    Image(systemName: store.isFavorite(restaurant) ? "heart.fill" : "heart")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(store.isFavorite(restaurant) ? AppColor.danger : .white)
                        .padding(10)
                        .background(.black.opacity(0.35), in: Circle())
                }
                .padding(10)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(restaurant.name)
                        .font(.cardTitle)
                        .foregroundStyle(AppColor.textPrimary)
                        .lineLimit(1)
                    Spacer()
                    Text(restaurant.priceTier.symbol)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppColor.textSecondary)
                }

                Text("\(restaurant.cuisine.icon) \(restaurant.cuisine.arabicName) · \(restaurant.neighborhood)")
                    .font(.caption)
                    .foregroundStyle(AppColor.textSecondary)
                    .lineLimit(1)

                RatingBadge(rating: restaurant.rating, reviewCount: restaurant.reviewCount)
                    .padding(.top, 2)
            }
            .padding(.horizontal, 4)
        }
        .padding(AppSpacing.sm)
        .background(AppColor.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
    }
}
