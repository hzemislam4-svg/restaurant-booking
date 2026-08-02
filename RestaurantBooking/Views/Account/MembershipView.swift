import SwiftUI

struct MembershipView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    IconBackButton { store.flow = .account }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

                VStack(alignment: .trailing, spacing: 0) {
                    Text("العضوية المميزة")
                        .font(.appFont(24, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, 4)

                    Text("أولوية في الحجز، بدون رسوم إلغاء، وطاولات حصرية")
                        .font(.appFont(13))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, 18)

                    HStack(spacing: 10) {
                        ForEach(MockData.plans) { plan in
                            let selected = store.selectedPlan == plan.id
                            Button {
                                store.selectedPlan = plan.id
                            } label: {
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text(plan.label)
                                        .font(.appFont(13))
                                        .foregroundStyle(Theme.textPrimary)
                                    Text(plan.price)
                                        .font(.appFont(20, weight: .bold))
                                        .foregroundStyle(Theme.textPrimary)
                                    Text(plan.period)
                                        .font(.appFont(11))
                                        .foregroundStyle(Theme.textSecondary)
                                    if let badge = plan.badge {
                                        TagView(text: badge, accent: true)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(selected ? Theme.purple.opacity(0.12) : .clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(selected ? Theme.purple : Theme.divider)
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom, 20)

                    VStack(alignment: .trailing, spacing: 10) {
                        featureRow("حجز أولوية في المطاعم المزدحمة")
                        featureRow("بدون رسوم إلغاء أو تعديل")
                        featureRow("الوصول إلى طاولات حصرية")
                        featureRow("دعم عملاء على مدار الساعة")
                    }
                    .padding(.bottom, 20)

                    PrimaryButton(title: "اشترك الآن", accentColor: store.accentColor) {
                        let plan = MockData.plans.first(where: { $0.id == store.selectedPlan }) ?? MockData.plans[0]
                        store.flow = .payment(plan)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
            }
        }
        .scrollIndicators(.hidden)
        .environment(\.layoutDirection, .rightToLeft)
    }

    private func featureRow(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Theme.success)
            Text(text)
                .font(.appFont(13))
                .foregroundStyle(Theme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
