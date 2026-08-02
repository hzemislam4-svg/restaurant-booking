//
//  FavoritesView.swift
//  RestaurantBooking
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var restaurantRepo: RestaurantRepository
    private let columns = [GridItem(.flexible(), spacing: AppSpacing.md), GridItem(.flexible(), spacing: AppSpacing.md)]

    var body: some View {
        NavigationStack {
            ScrollView {
                if store.favoriteRestaurants(from: restaurantRepo.restaurants).isEmpty {
                    emptyState
                } else {
                    LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                        ForEach(store.favoriteRestaurants(from: restaurantRepo.restaurants)) { restaurant in
                            NavigationLink(value: restaurant) {
                                RestaurantCard(restaurant: restaurant)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(AppSpacing.md)
                }
            }
            .background(AppColor.background)
            .navigationTitle("المفضلة")
            .navigationDestination(for: Restaurant.self) { restaurant in
                RestaurantDetailView(restaurant: restaurant)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: "heart")
                .font(.system(size: 44))
                .foregroundStyle(AppColor.textTertiary)
            Text("لا توجد مفضلات بعد")
                .font(.headline)
            Text("اضغط القلب في أي مطعم لحفظه هنا.")
                .font(.subheadline)
                .foregroundStyle(AppColor.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, AppSpacing.xl)
        .padding(.top, 80)
    }
}

#Preview {
    FavoritesView()
        .environmentObject(AppStore())
        .environmentObject(RestaurantRepository())
}
