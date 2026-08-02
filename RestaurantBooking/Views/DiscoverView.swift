//
//  DiscoverView.swift
//  RestaurantBooking
//

import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var restaurantRepo: RestaurantRepository
    @State private var searchText = ""
    @State private var selectedCuisine: Cuisine?

    private var filteredRestaurants: [Restaurant] {
        restaurantRepo.restaurants.filter { restaurant in
            let matchesSearch = searchText.isEmpty
                || restaurant.name.localizedCaseInsensitiveContains(searchText)
                || restaurant.neighborhood.localizedCaseInsensitiveContains(searchText)
            let matchesCuisine = selectedCuisine == nil || restaurant.cuisine == selectedCuisine
            return matchesSearch && matchesCuisine
        }
    }

    private var featured: [Restaurant] {
        restaurantRepo.restaurants.sorted { $0.rating > $1.rating }.prefix(3).map { $0 }
    }

    private let columns = [GridItem(.flexible(), spacing: AppSpacing.md), GridItem(.flexible(), spacing: AppSpacing.md)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    header

                    searchBar

                    cuisineFilterRow

                    if searchText.isEmpty && selectedCuisine == nil && !restaurantRepo.restaurants.isEmpty {
                        featuredSection
                    }

                    sectionHeader(searchText.isEmpty && selectedCuisine == nil ? "كل المطاعم" : "النتائج")

                    LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                        ForEach(filteredRestaurants) { restaurant in
                            NavigationLink(value: restaurant) {
                                RestaurantCard(restaurant: restaurant)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)

                    if filteredRestaurants.isEmpty {
                        emptyState
                    }
                }
                .padding(.bottom, AppSpacing.xl)
            }
            .background(AppColor.background)
            .navigationBarHidden(true)
            .navigationDestination(for: Restaurant.self) { restaurant in
                RestaurantDetailView(restaurant: restaurant)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("مساء الخير")
                .font(.subheadline)
                .foregroundStyle(AppColor.textSecondary)
            Text("وين الليلة؟")
                .font(.displayTitle)
                .foregroundStyle(AppColor.textPrimary)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.sm)
    }

    private var searchBar: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppColor.textSecondary)
            TextField("ابحث عن مطاعم أو أحياء", text: $searchText)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, 12)
        .background(AppColor.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.pill, style: .continuous))
        .padding(.horizontal, AppSpacing.md)
    }

    private var cuisineFilterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                cuisineChip(label: "الكل", isSelected: selectedCuisine == nil) {
                    selectedCuisine = nil
                }
                ForEach(Cuisine.allCases) { cuisine in
                    cuisineChip(label: "\(cuisine.icon) \(cuisine.arabicName)", isSelected: selectedCuisine == cuisine) {
                        selectedCuisine = (selectedCuisine == cuisine) ? nil : cuisine
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
    }

    private func cuisineChip(label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) { action() }
        }) {
            Text(label)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? AppColor.accent : AppColor.secondaryBackground)
                .foregroundStyle(isSelected ? .white : AppColor.textPrimary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            sectionHeader("مميز الليلة")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(featured) { restaurant in
                        NavigationLink(value: restaurant) {
                            FeaturedCard(restaurant: restaurant)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
            }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.sectionTitle)
            .foregroundStyle(AppColor.textPrimary)
            .padding(.horizontal, AppSpacing.md)
    }

    private var emptyState: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 40))
                .foregroundStyle(AppColor.textTertiary)
            if restaurantRepo.restaurants.isEmpty {
                Text("لا توجد مطاعم بعد")
                    .font(.headline)
                Text("كن الأول — سجّل كصاحب مطعم وأضف واحداً.")
                    .font(.subheadline)
                    .foregroundStyle(AppColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xl)
            } else {
                Text("لا توجد مطاعم تطابق بحثك")
                    .font(.subheadline)
                    .foregroundStyle(AppColor.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppSpacing.xl)
    }
}

private struct FeaturedCard: View {
    let restaurant: Restaurant

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RestaurantPhotoView(restaurant: restaurant, cornerRadius: AppRadius.lg)
                .frame(width: 260, height: 150)
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.65)],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.headline)
                    .foregroundStyle(.white)
                HStack(spacing: 6) {
                    RatingBadge(rating: restaurant.rating, reviewCount: nil, compact: true)
                    Text("· \(restaurant.neighborhood)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.85))
                }
            }
            .padding(AppSpacing.md)
        }
        .frame(width: 260, height: 150)
    }
}

#Preview {
    DiscoverView()
        .environmentObject(AppStore())
        .environmentObject(RestaurantRepository())
}
