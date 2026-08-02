//
//  OwnerPaywallView.swift
//  RestaurantBooking
//
//  Subscription screen for restaurant owners. Required before a "My
//  Restaurant" listing can be created - same mock-purchase pattern as
//  the diner paywall, no real payment processor involved yet.
//

import SwiftUI

struct OwnerPaywallView: View {
    @EnvironmentObject private var subscriptions: SubscriptionStore
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPlan: SubscriptionPlan = .yearly
    @State private var showSuccess = false

    private let benefits = [
        ("storefront.fill", "اعرض مطعمك لكل زبون يستخدم التطبيق"),
        ("photo.on.rectangle.angled", "ارفع صوراً غير محدودة لمكانك وقائمتك"),
        ("calendar.badge.checkmark", "استقبل وأدر حجوزات الطاولات"),
        ("chart.bar.fill", "شاهد كم زبوناً يطّلع ويحجز في مطعمك"),
    ]

    var body: some View {
        NavigationStack {
            if showSuccess {
                successView
            } else {
                form
            }
        }
    }

    private var form: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                VStack(spacing: 8) {
                    Image(systemName: "storefront.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(AppColor.accent)
                    Text("شريك المطاعم")
                        .font(.displayTitle)
                    Text("اعرض مطعمك وابدأ باستقبال الحجوزات")
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
                        subscriptions.subscribeOwner(to: selectedPlan)
                        showSuccess = true
                    }
                } label: {
                    Text("اشترك — \(OwnerPlanPricing.price(for: selectedPlan))")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColor.accent)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
                }

                Text("هذه عملية شراء تجريبية — لا تُعالج أي دفعة حقيقية ولن يُحتسب أي مبلغ على حسابك.")
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
                        Text(plan.title).font(.subheadline.weight(.semibold))
                        if plan == .yearly {
                            Text(OwnerPlanPricing.yearlyBadge)
                                .font(.caption2.weight(.semibold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(AppColor.gold.opacity(0.2))
                                .foregroundStyle(AppColor.gold)
                                .clipShape(Capsule())
                        }
                    }
                    Text(OwnerPlanPricing.price(for: plan))
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
            Image(systemName: "storefront.fill")
                .font(.system(size: 64))
                .foregroundStyle(AppColor.accent)
            Text("أنت شريك الآن")
                .font(.title2.bold())
            Text("لنضيف مطعمك.")
                .font(.subheadline)
                .foregroundStyle(AppColor.textSecondary)
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("متابعة")
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
}

#Preview {
    OwnerPaywallView()
        .environmentObject(SubscriptionStore())
}
