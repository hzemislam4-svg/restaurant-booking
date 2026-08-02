//
//  MyRestaurantView.swift
//  RestaurantBooking
//
//  Entry point for restaurant owners - shows their published listing(s)
//  or prompts them to subscribe + add one if they haven't yet.
//

import SwiftUI

struct MyRestaurantView: View {
    @EnvironmentObject private var auth: FirebaseAuthService
    @EnvironmentObject private var subscriptions: SubscriptionStore
    @EnvironmentObject private var restaurantRepo: RestaurantRepository

    @State private var showOwnerPaywall = false
    @State private var showAddRestaurant = false

    private var myRestaurants: [Restaurant] {
        guard let uid = auth.currentUser?.uid else { return [] }
        return restaurantRepo.restaurants(ownedBy: uid)
    }

    var body: some View {
        NavigationStack {
            Group {
                if !subscriptions.isOwnerSubscribed {
                    notSubscribedState
                } else if myRestaurants.isEmpty {
                    noRestaurantYetState
                } else {
                    restaurantList
                }
            }
            .navigationTitle("مطعمي")
            .sheet(isPresented: $showOwnerPaywall) {
                OwnerPaywallView()
            }
            .sheet(isPresented: $showAddRestaurant) {
                AddRestaurantView()
            }
        }
    }

    private var notSubscribedState: some View {
        VStack(spacing: AppSpacing.md) {
            Spacer()
            Image(systemName: "storefront")
                .font(.system(size: 48))
                .foregroundStyle(AppColor.textTertiary)
            Text("كن شريكاً للمطاعم")
                .font(.headline)
            Text("اشترك لعرض مطعمك وابدأ باستقبال الحجوزات من الزبائن الذين يستخدمون التطبيق.")
                .font(.subheadline)
                .foregroundStyle(AppColor.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
            Button {
                showOwnerPaywall = true
            } label: {
                Text("عرض خطط الشركاء")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, 14)
                    .background(AppColor.accent)
                    .clipShape(Capsule())
            }
            Spacer()
        }
    }

    private var noRestaurantYetState: some View {
        VStack(spacing: AppSpacing.md) {
            Spacer()
            Image(systemName: "plus.circle")
                .font(.system(size: 48))
                .foregroundStyle(AppColor.accent)
            Text("أضف مطعمك")
                .font(.headline)
            Text("اشتراكك مفعّل. أضف تفاصيل مطعمك وصوره ليصبح مرئياً لكل زبون في التطبيق.")
                .font(.subheadline)
                .foregroundStyle(AppColor.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
            Button {
                showAddRestaurant = true
            } label: {
                Text("إضافة مطعم")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, 14)
                    .background(AppColor.accent)
                    .clipShape(Capsule())
            }
            Spacer()
        }
    }

    private var restaurantList: some View {
        List {
            ForEach(myRestaurants) { restaurant in
                HStack(spacing: AppSpacing.sm) {
                    RestaurantImagePlaceholder(cuisine: restaurant.cuisine)
                        .frame(width: 56, height: 56)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(restaurant.name).font(.subheadline.weight(.semibold))
                        Text(restaurant.isPublished ? "منشور — مرئي للزبائن" : "مخفي")
                            .font(.caption)
                            .foregroundStyle(restaurant.isPublished ? AppColor.success : AppColor.textSecondary)
                        if !restaurant.hasRealPhotos {
                            Text("لا توجد صور بعد")
                                .font(.caption2)
                                .foregroundStyle(AppColor.danger)
                        }
                    }
                }
            }

            Section {
                Button {
                    showAddRestaurant = true
                } label: {
                    Label("إضافة مطعم آخر", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    MyRestaurantView()
        .environmentObject(FirebaseAuthService())
        .environmentObject(SubscriptionStore())
        .environmentObject(RestaurantRepository())
}
