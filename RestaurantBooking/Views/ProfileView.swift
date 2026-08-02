//
//  ProfileView.swift
//  RestaurantBooking
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var favorites: AppStore
    @EnvironmentObject private var auth: FirebaseAuthService
    @EnvironmentObject private var subscriptions: SubscriptionStore
    @EnvironmentObject private var restaurantRepo: RestaurantRepository
    @EnvironmentObject private var reservationRepo: ReservationRepository
    @State private var showDinerPaywall = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: AppSpacing.md) {
                        Circle()
                            .fill(AppColor.accentSoft)
                            .frame(width: 56, height: 56)
                            .overlay(
                                Text(initials)
                                    .font(.headline)
                                    .foregroundStyle(AppColor.accent)
                            )
                        VStack(alignment: .leading, spacing: 2) {
                            Text(auth.currentUser?.displayName ?? "ضيف")
                                .font(.headline)
                            if subscriptions.isDinerSubscribed, let plan = subscriptions.dinerPlan {
                                Label("نادي الطاولة · \(plan.title)", systemImage: "crown.fill")
                                    .font(.caption)
                                    .foregroundStyle(AppColor.gold)
                            } else {
                                Text("حساب مجاني")
                                    .font(.caption)
                                    .foregroundStyle(AppColor.textSecondary)
                            }
                        }
                    }
                    .padding(.vertical, 6)
                }

                if !subscriptions.isDinerSubscribed {
                    Section {
                        upgradeRow(
                            icon: "crown.fill",
                            title: "الترقية إلى نادي الطاولة",
                            subtitle: "طاولات ذات أولوية، خصومات للأعضاء والمزيد"
                        ) { showDinerPaywall = true }
                    }
                } else {
                    Section("العضوية") {
                        HStack {
                            Text("الخطة")
                            Spacer()
                            Text(subscriptions.dinerPlan?.title ?? "—")
                                .foregroundStyle(AppColor.textSecondary)
                        }
                        Button(role: .destructive) {
                            subscriptions.cancelDinerSubscription()
                        } label: {
                            Text("إلغاء العضوية")
                        }
                    }
                }

                Section("لأصحاب المطاعم") {
                    NavigationLink {
                        MyRestaurantView()
                    } label: {
                        Label(
                            subscriptions.isOwnerSubscribed ? "مطعمي" : "كن شريكاً للمطاعم",
                            systemImage: "storefront"
                        )
                    }
                }

                Section("النشاط") {
                    statRow(icon: "heart.fill", label: "المطاعم المفضلة", value: "\(favorites.favoriteRestaurants(from: restaurantRepo.restaurants).count)")
                    statRow(icon: "calendar", label: "الحجوزات القادمة", value: "\(reservationRepo.upcomingReservations.count)")
                }

                Section("التفضيلات") {
                    NavigationLink {
                        NotificationsSettingsView()
                    } label: {
                        Label("الإشعارات", systemImage: "bell")
                    }
                    NavigationLink {
                        PaymentMethodsView()
                    } label: {
                        Label("طرق الدفع", systemImage: "creditcard")
                    }
                    NavigationLink {
                        LanguageView()
                    } label: {
                        Label("اللغة", systemImage: "globe")
                    }
                }

                Section("الدعم") {
                    NavigationLink {
                        HelpCenterView()
                    } label: {
                        Label("مركز المساعدة", systemImage: "questionmark.circle")
                    }
                    NavigationLink {
                        ContactUsView()
                    } label: {
                        Label("تواصل معنا", systemImage: "envelope")
                    }
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("حول التطبيق", systemImage: "info.circle")
                    }
                }

                Section {
                    Button(role: .destructive) {
                        auth.logOut()
                    } label: {
                        Text("تسجيل الخروج")
                            .frame(maxWidth: .infinity)
                    }
                }

                Section {
                    Text("حجز المطاعم v1.0.0")
                        .font(.caption)
                        .foregroundStyle(AppColor.textTertiary)
                        .frame(maxWidth: .infinity)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("الملف الشخصي")
            .sheet(isPresented: $showDinerPaywall) {
                PaywallView()
            }
        }
    }

    private var initials: String {
        let name = auth.currentUser?.displayName ?? "ضيف"
        let parts = name.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first }
        return String(letters).uppercased()
    }

    private func upgradeRow(icon: String, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon).foregroundStyle(AppColor.gold)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppColor.textPrimary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(AppColor.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(AppColor.textTertiary)
            }
        }
    }

    private func statRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Label(label, systemImage: icon)
            Spacer()
            Text(value)
                .foregroundStyle(AppColor.textSecondary)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppStore())
        .environmentObject(FirebaseAuthService())
        .environmentObject(SubscriptionStore())
        .environmentObject(RestaurantRepository())
        .environmentObject(ReservationRepository())
}
