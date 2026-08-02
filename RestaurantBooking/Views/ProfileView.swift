//
//  ProfileView.swift
//  RestaurantBooking
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var auth: AuthStore
    @EnvironmentObject private var subscriptions: SubscriptionStore
    @State private var showPaywall = false

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
                            Text(auth.currentDisplayName)
                                .font(.headline)
                            if subscriptions.isSubscribed, let plan = subscriptions.activePlan {
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

                if !subscriptions.isSubscribed {
                    Section {
                        Button {
                            showPaywall = true
                        } label: {
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundStyle(AppColor.gold)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("الترقية إلى نادي الطاولة")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(AppColor.textPrimary)
                                    Text("طاولات ذات أولوية، خصومات للأعضاء والمزيد")
                                        .font(.caption)
                                        .foregroundStyle(AppColor.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.left")
                                    .font(.caption)
                                    .foregroundStyle(AppColor.textTertiary)
                            }
                        }
                    }
                } else {
                    Section("العضوية") {
                        HStack {
                            Text("الخطة")
                            Spacer()
                            Text(subscriptions.activePlan?.title ?? "—")
                                .foregroundStyle(AppColor.textSecondary)
                        }
                        Button(role: .destructive) {
                            subscriptions.cancelSubscription()
                        } label: {
                            Text("إلغاء العضوية")
                        }
                    }
                }

                Section("النشاط") {
                    statRow(icon: "heart.fill", label: "المطاعم المفضلة", value: "\(store.favoriteRestaurants.count)")
                    statRow(icon: "calendar", label: "الحجوزات القادمة", value: "\(store.upcomingReservations.count)")
                }

                Section("التفضيلات") {
                    Label("الإشعارات", systemImage: "bell")
                    NavigationLink {
                        PaymentMethodsView()
                    } label: {
                        Label("طرق الدفع", systemImage: "creditcard")
                    }
                    Label("اللغة", systemImage: "globe")
                }

                Section("الدعم") {
                    Label("مركز المساعدة", systemImage: "questionmark.circle")
                    Label("تواصل معنا", systemImage: "envelope")
                    Label("حول التطبيق", systemImage: "info.circle")
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
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }

    private var initials: String {
        let parts = auth.currentDisplayName.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first }
        return String(letters).uppercased()
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
        .environmentObject(AuthStore())
        .environmentObject(SubscriptionStore())
}
