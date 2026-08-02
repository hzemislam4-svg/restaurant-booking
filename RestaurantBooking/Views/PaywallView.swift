//
//  PaywallView.swift
//  RestaurantBooking
//

import SwiftUI

struct PaywallView: View {
    @EnvironmentObject private var subscriptions: SubscriptionStore
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPlan: SubscriptionPlan = .yearly
    @State private var showSuccess = false

    private let benefits = [
        ("bolt.fill", "أولوية في توفر الطاولات بأفضل المطاعم"),
        ("percent", "خصومات حصرية للمشتركين على قوائم مختارة"),
        ("bell.badge.fill", "وصول مبكر لافتتاح المطاعم الجديدة"),
        ("star.fill", "بدون رسوم على الحجوزات في اللحظة الأخيرة"),
    ]

    var body: some View {
        NavigationStack {
            if showSuccess {
                successView
            } else {
                paywallForm
            }
        }
    }

    private var paywallForm: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                VStack(spacing: 8) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(AppColor.gold)
                    Text("نادي الطاولة")
                        .font(.displayTitle)
                    Text("افتح تجربة الحجز الكاملة")
                        .font(.subheadline)
                        .foregroundStyle(AppColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, AppSpacing.md)

                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    ForEach(benefits, id: \.1) { icon, text in
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: icon)
                                .foregroundStyle(AppColor.accent)
                                .frame(width: 26)
                            Text(text)
                                .font(.subheadline)
                                .foregroundStyle(AppColor.textPrimary)
                        }
                    }
                }
                .padding(AppSpacing.md)
                .background(AppColor.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))

                VStack(spacing: AppSpacing.sm) {
                    ForEach(SubscriptionPlan.allCases) { plan in
                        planCard(plan)
                    }
                }

                Button {
                    withAnimation {
                        subscriptions.subscribe(to: selectedPlan)
                        showSuccess = true
                    }
                } label: {
                    Text("اشترك الآن — \(selectedPlan.price)")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColor.accent)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
                }

                Text("هذه عملية شراء تجريبية — لا تُخصم أي مبالغ حقيقية ولن يُحتسب أي مبلغ على حسابك.")
                    .font(.caption2)
                    .foregroundStyle(AppColor.textTertiary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xl)
        }
        .background(AppColor.background)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("إغلاق") { dismiss() }
            }
        }
    }

    private func planCard(_ plan: SubscriptionPlan) -> some View {
        Button {
            selectedPlan = plan
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(plan.title)
                            .font(.subheadline.weight(.semibold))
                        if let badge = plan.badge {
                            Text(badge)
                                .font(.caption2.weight(.semibold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(AppColor.gold.opacity(0.2))
                                .foregroundStyle(AppColor.gold)
                                .clipShape(Capsule())
                        }
                    }
                    Text(plan.price)
                        .font(.caption)
                        .foregroundStyle(AppColor.textSecondary)
                }
                Spacer()
                Image(systemName: selectedPlan == plan ? "largecircle.fill.circle" : "circle")
                    .foregroundStyle(selectedPlan == plan ? AppColor.accent : AppColor.textTertiary)
                    .font(.system(size: 20))
            }
            .padding(AppSpacing.md)
            .background(selectedPlan == plan ? AppColor.accentSoft : AppColor.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                    .stroke(selectedPlan == plan ? AppColor.accent : .clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    private var successView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            Image(systemName: "crown.fill")
                .font(.system(size: 64))
                .foregroundStyle(AppColor.gold)
            Text("أهلاً بك في نادي الطاولة")
                .font(.title2.bold())
            Text("اشتراكك \(planLabel) مفعّل الآن.")
                .font(.subheadline)
                .foregroundStyle(AppColor.textSecondary)
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("تم")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColor.accent)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.md)
        }
    }

    private var planLabel: String {
        selectedPlan == .yearly ? "السنوي" : "الشهري"
    }
}

#Preview {
    PaywallView()
        .environmentObject(SubscriptionStore())
}
