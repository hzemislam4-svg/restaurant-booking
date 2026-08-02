//
//  ProfileView.swift
//  RestaurantBooking
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: AppSpacing.md) {
                        Circle()
                            .fill(AppColor.accentSoft)
                            .frame(width: 56, height: 56)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundStyle(AppColor.accent)
                                    .font(.system(size: 22))
                            )
                        VStack(alignment: .leading, spacing: 2) {
                            Text("ضيف")
                                .font(.headline)
                            Text("سجّل الدخول لمزامنة حجوزاتك")
                                .font(.caption)
                                .foregroundStyle(AppColor.textSecondary)
                        }
                    }
                    .padding(.vertical, 6)
                }

                Section("النشاط") {
                    statRow(icon: "heart.fill", label: "المطاعم المفضلة", value: "\(store.favoriteRestaurants.count)")
                    statRow(icon: "calendar", label: "الحجوزات القادمة", value: "\(store.upcomingReservations.count)")
                }

                Section("التفضيلات") {
                    Label("الإشعارات", systemImage: "bell")
                    Label("طرق الدفع", systemImage: "creditcard")
                    Label("اللغة", systemImage: "globe")
                }

                Section("الدعم") {
                    Label("مركز المساعدة", systemImage: "questionmark.circle")
                    Label("تواصل معنا", systemImage: "envelope")
                    Label("حول التطبيق", systemImage: "info.circle")
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
}
