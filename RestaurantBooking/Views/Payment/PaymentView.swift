import SwiftUI

struct PaymentView: View {
    @EnvironmentObject var store: AppStore
    let plan: Plan

    @State private var cardNumber = ""
    @State private var cardName = ""
    @State private var expiry = ""
    @State private var cvv = ""
    @State private var isProcessing = false
    @State private var showSuccess = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    IconBackButton { store.flow = .membership }
                    Text("بوابة الدفع")
                        .font(.appFont(17, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

                VStack(alignment: .trailing, spacing: 16) {
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("الاشتراك في العضوية")
                                .font(.appFont(12))
                                .foregroundStyle(Theme.textSecondary)
                            Text("\(plan.price) \(plan.period)")
                                .font(.appFont(20, weight: .bold))
                                .foregroundStyle(Theme.textPrimary)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.radiusMd)
                            .fill(Theme.success.opacity(0.1))
                            .overlay(RoundedRectangle(cornerRadius: Theme.radiusMd).stroke(Theme.success.opacity(0.3)))
                    )

                    VStack(alignment: .trailing, spacing: 6) {
                        Text("رقم البطاقة")
                            .font(.appFont(13, weight: .medium))
                            .foregroundStyle(Theme.textPrimary)
                        TextField("0000 0000 0000 0000", text: $cardNumber)
                            .font(.appFont(14))
                            .foregroundStyle(Theme.textPrimary)
                            .keyboardType(.numberPad)
                            .padding(12)
                            .background(fieldStyle)
                    }

                    VStack(alignment: .trailing, spacing: 6) {
                        Text("الاسم على البطاقة")
                            .font(.appFont(13, weight: .medium))
                            .foregroundStyle(Theme.textPrimary)
                        TextField("الاسم الكامل", text: $cardName)
                            .font(.appFont(14))
                            .foregroundStyle(Theme.textPrimary)
                            .padding(12)
                            .background(fieldStyle)
                    }

                    HStack(spacing: 12) {
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("تاريخ الانتهاء")
                                .font(.appFont(13, weight: .medium))
                                .foregroundStyle(Theme.textPrimary)
                            TextField("MM/YY", text: $expiry)
                                .font(.appFont(14))
                                .foregroundStyle(Theme.textPrimary)
                                .keyboardType(.numberPad)
                                .padding(12)
                                .background(fieldStyle)
                        }
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("رمز الأمان")
                                .font(.appFont(13, weight: .medium))
                                .foregroundStyle(Theme.textPrimary)
                            SecureField("CVV", text: $cvv)
                                .font(.appFont(14))
                                .foregroundStyle(Theme.textPrimary)
                                .keyboardType(.numberPad)
                                .padding(12)
                                .background(fieldStyle)
                        }
                    }

                    Text("هذه بوابة دفع تجريبية — لن يتم خصم أي مبلغ من بطاقتك.")
                        .font(.appFont(11))
                        .foregroundStyle(Theme.textMuted)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    PrimaryButton(title: isProcessing ? "جارٍ المعالجة..." : "إتمام الدفع",
                                  accentColor: store.accentColor) {
                        processPayment()
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
        .scrollIndicators(.hidden)
        .overlay {
            if showSuccess {
                PaymentSuccessOverlay {
                    store.subscribe(to: plan)
                    showSuccess = false
                    store.flow = nil
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }

    private var fieldStyle: some View {
        RoundedRectangle(cornerRadius: Theme.radiusSm)
            .fill(Color.white.opacity(0.06))
            .overlay(RoundedRectangle(cornerRadius: Theme.radiusSm).stroke(Theme.divider))
    }

    private func processPayment() {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isProcessing = false
            showSuccess = true
        }
    }
}

struct PaymentSuccessOverlay: View {
    let done: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack(spacing: 14) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.success)
                Text("تم الدفع بنجاح")
                    .font(.appFont(18, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)
                Text("تم تفعيل عضويتك المميزة")
                    .font(.appFont(13))
                    .foregroundStyle(Theme.textSecondary)
                PrimaryButton(title: "تم", accentColor: Theme.success) {
                    done()
                }
                .frame(width: 140)
                .padding(.top, 6)
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Theme.surface)
            )
            .padding(40)
        }
    }
}
