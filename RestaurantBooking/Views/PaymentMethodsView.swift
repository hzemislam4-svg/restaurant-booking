//
//  PaymentMethodsView.swift
//  RestaurantBooking
//

import SwiftUI

struct PaymentMethodsView: View {
    @EnvironmentObject private var subscriptions: SubscriptionStore
    @State private var showAddCard = false

    var body: some View {
        List {
            if subscriptions.savedCards.isEmpty {
                Section {
                    VStack(spacing: AppSpacing.sm) {
                        Image(systemName: "creditcard")
                            .font(.system(size: 36))
                            .foregroundStyle(AppColor.textTertiary)
                        Text("لا توجد بطاقات محفوظة بعد")
                            .font(.subheadline)
                            .foregroundStyle(AppColor.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .listRowSeparator(.hidden)
                }
            } else {
                Section("البطاقات المحفوظة") {
                    ForEach(subscriptions.savedCards) { card in
                        cardRow(card)
                    }
                    .onDelete { offsets in
                        offsets.map { subscriptions.savedCards[$0] }.forEach(subscriptions.removeCard)
                    }
                }
            }

            Section {
                Button {
                    showAddCard = true
                } label: {
                    Label("إضافة بطاقة", systemImage: "plus.circle.fill")
                }
            }

            Section {
                Text("تُحفظ بيانات البطاقة محلياً على هذا الجهاز لأغراض تجريبية فقط، ولا تُرسل إلى أي مكان ولا تُحصّل أي مبلغ.")
                    .font(.caption2)
                    .foregroundStyle(AppColor.textTertiary)
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("طرق الدفع")
        .sheet(isPresented: $showAddCard) {
            AddCardView()
        }
    }

    private func cardRow(_ card: SavedCard) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "creditcard.fill")
                .font(.system(size: 22))
                .foregroundStyle(AppColor.accent)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(card.brand) •••• \(card.last4)")
                    .font(.subheadline.weight(.semibold))
                Text("\(card.cardholderName) · تنتهي \(card.expiry)")
                    .font(.caption)
                    .foregroundStyle(AppColor.textSecondary)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct AddCardView: View {
    @EnvironmentObject private var subscriptions: SubscriptionStore
    @Environment(\.dismiss) private var dismiss

    @State private var cardholderName = ""
    @State private var cardNumber = ""
    @State private var expiry = ""
    @State private var cvv = ""

    private var canSave: Bool {
        !cardholderName.isEmpty && cardNumber.filter(\.isNumber).count >= 12 && expiry.count == 5 && cvv.count >= 3
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("بيانات البطاقة") {
                    TextField("اسم حامل البطاقة", text: $cardholderName)
                        .textInputAutocapitalization(.words)

                    TextField("رقم البطاقة", text: $cardNumber)
                        .keyboardType(.numberPad)
                        .onChange(of: cardNumber) { _, newValue in
                            cardNumber = Self.formatCardNumber(newValue)
                        }

                    HStack {
                        TextField("MM/YY", text: $expiry)
                            .keyboardType(.numberPad)
                            .onChange(of: expiry) { _, newValue in
                                expiry = Self.formatExpiry(newValue)
                            }
                        Divider()
                        TextField("CVV", text: $cvv)
                            .keyboardType(.numberPad)
                            .onChange(of: cvv) { _, newValue in
                                cvv = String(newValue.filter(\.isNumber).prefix(4))
                            }
                    }
                }

                Section {
                    Text("نموذج تجريبي — لا يتصل بأي بوابة دفع ولا يحدث أي خصم.")
                        .font(.caption2)
                        .foregroundStyle(AppColor.textTertiary)
                }
            }
            .navigationTitle("إضافة بطاقة")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("إلغاء") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("حفظ") {
                        subscriptions.addCard(cardholderName: cardholderName, cardNumber: cardNumber, expiry: expiry)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private static func formatCardNumber(_ value: String) -> String {
        let digits = String(value.filter(\.isNumber).prefix(16))
        var formatted = ""
        for (index, char) in digits.enumerated() {
            if index != 0 && index % 4 == 0 { formatted += " " }
            formatted.append(char)
        }
        return formatted
    }

    private static func formatExpiry(_ value: String) -> String {
        let digits = String(value.filter(\.isNumber).prefix(4))
        if digits.count <= 2 { return digits }
        let month = digits.prefix(2)
        let year = digits.suffix(digits.count - 2)
        return "\(month)/\(year)"
    }
}

#Preview {
    NavigationStack {
        PaymentMethodsView()
    }
    .environmentObject(SubscriptionStore())
}
