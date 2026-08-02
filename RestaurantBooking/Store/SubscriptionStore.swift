//
//  SubscriptionStore.swift
//  RestaurantBooking
//
//  Mock subscription + saved cards. Pressing "Subscribe" flips a local
//  flag and saves a fake "receipt" - it does NOT contact Apple, Stripe,
//  or any payment processor, and no real money moves. This matches
//  what you asked for: the paywall should look and feel real, but not
//  be wired to a real payment gateway yet.
//
//  When you're ready to take real payments, this is the file to
//  replace with RevenueCat/StoreKit - the UI in PaywallView.swift and
//  PaymentMethodsView.swift can stay almost exactly as-is.
//

import Foundation
import Combine

struct SavedCard: Identifiable, Codable {
    let id: UUID
    let cardholderName: String
    let last4: String
    let expiry: String
    let brand: String

    init(id: UUID = UUID(), cardholderName: String, last4: String, expiry: String, brand: String) {
        self.id = id
        self.cardholderName = cardholderName
        self.last4 = last4
        self.expiry = expiry
        self.brand = brand
    }
}

enum SubscriptionPlan: String, CaseIterable, Identifiable {
    case monthly
    case yearly

    var id: String { rawValue }

    var title: String {
        switch self {
        case .monthly: return "شهري"
        case .yearly: return "سنوي"
        }
    }

    var price: String {
        switch self {
        case .monthly: return "$6.99 / شهرياً"
        case .yearly: return "$59.99 / سنوياً"
        }
    }

    var badge: String? {
        self == .yearly ? "الأفضل قيمة — وفّر 28%" : nil
    }
}

@MainActor
final class SubscriptionStore: ObservableObject {
    @Published private(set) var isSubscribed: Bool = false
    @Published private(set) var activePlan: SubscriptionPlan?
    @Published private(set) var savedCards: [SavedCard] = []

    private let subscribedKey = "isSubscribedPro"
    private let planKey = "activeSubscriptionPlan"
    private let cardsKey = "savedPaymentCards"

    init() {
        isSubscribed = UserDefaults.standard.bool(forKey: subscribedKey)
        if let rawPlan = UserDefaults.standard.string(forKey: planKey) {
            activePlan = SubscriptionPlan(rawValue: rawPlan)
        }
        loadCards()
    }

    /// Simulates a successful purchase. Real integration point for
    /// StoreKit/RevenueCat later.
    func subscribe(to plan: SubscriptionPlan) {
        isSubscribed = true
        activePlan = plan
        UserDefaults.standard.set(true, forKey: subscribedKey)
        UserDefaults.standard.set(plan.rawValue, forKey: planKey)
    }

    func cancelSubscription() {
        isSubscribed = false
        activePlan = nil
        UserDefaults.standard.set(false, forKey: subscribedKey)
        UserDefaults.standard.removeObject(forKey: planKey)
    }

    // MARK: - Cards (UI only - never sent anywhere, no real validation)

    func addCard(cardholderName: String, cardNumber: String, expiry: String) {
        let digitsOnly = cardNumber.filter(\.isNumber)
        let last4 = String(digitsOnly.suffix(4))
        let brand = Self.detectBrand(from: digitsOnly)

        let card = SavedCard(cardholderName: cardholderName, last4: last4, expiry: expiry, brand: brand)
        savedCards.append(card)
        saveCards()
    }

    func removeCard(_ card: SavedCard) {
        savedCards.removeAll { $0.id == card.id }
        saveCards()
    }

    private func saveCards() {
        guard let data = try? JSONEncoder().encode(savedCards) else { return }
        UserDefaults.standard.set(data, forKey: cardsKey)
    }

    private func loadCards() {
        guard
            let data = UserDefaults.standard.data(forKey: cardsKey),
            let decoded = try? JSONDecoder().decode([SavedCard].self, from: data)
        else { return }
        savedCards = decoded
    }

    private static func detectBrand(from digits: String) -> String {
        if digits.hasPrefix("4") { return "فيزا" }
        if digits.hasPrefix("5") { return "ماستركارد" }
        if digits.hasPrefix("3") { return "أميركان إكسبريس" }
        return "بطاقة"
    }
}
