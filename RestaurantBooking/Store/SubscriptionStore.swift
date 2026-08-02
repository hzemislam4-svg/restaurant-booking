//
//  SubscriptionStore.swift
//  RestaurantBooking
//
//  Mock subscriptions for BOTH sides of the app:
//   - Diner plan ("Table Club") - perks for people booking tables
//   - Owner plan ("Restaurant Partner") - required before a restaurant
//     owner can publish a listing
//
//  Still a mock purchase flow - no real payment processor is
//  contacted, matching what you asked for earlier. When you're ready
//  to charge real money, this is the file to replace with
//  RevenueCat/StoreKit; the paywalls in PaywallView.swift and
//  OwnerPaywallView.swift can stay almost exactly as they are.
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
    var title: String { self == .monthly ? "شهري" : "سنوي" }
}

enum DinerPlanPricing {
    static func price(for plan: SubscriptionPlan) -> String {
        plan == .monthly ? "$6.99 / شهرياً" : "$59.99 / سنوياً"
    }
    static let yearlyBadge = "الأفضل قيمة — وفّر 28%"
}

enum OwnerPlanPricing {
    static func price(for plan: SubscriptionPlan) -> String {
        plan == .monthly ? "$24.99 / شهرياً" : "$249.99 / سنوياً"
    }
    static let yearlyBadge = "الأفضل قيمة — شهران مجاناً"
}

@MainActor
final class SubscriptionStore: ObservableObject {
    @Published private(set) var isDinerSubscribed = false
    @Published private(set) var dinerPlan: SubscriptionPlan?

    @Published private(set) var isOwnerSubscribed = false
    @Published private(set) var ownerPlan: SubscriptionPlan?

    @Published private(set) var savedCards: [SavedCard] = []

    private let dinerKey = "isDinerSubscribed"
    private let dinerPlanKey = "dinerPlan"
    private let ownerKey = "isOwnerSubscribed"
    private let ownerPlanKey = "ownerPlan"
    private let cardsKey = "savedPaymentCards"

    init() {
        isDinerSubscribed = UserDefaults.standard.bool(forKey: dinerKey)
        if let raw = UserDefaults.standard.string(forKey: dinerPlanKey) {
            dinerPlan = SubscriptionPlan(rawValue: raw)
        }
        isOwnerSubscribed = UserDefaults.standard.bool(forKey: ownerKey)
        if let raw = UserDefaults.standard.string(forKey: ownerPlanKey) {
            ownerPlan = SubscriptionPlan(rawValue: raw)
        }
        loadCards()
    }

    func subscribeDiner(to plan: SubscriptionPlan) {
        isDinerSubscribed = true
        dinerPlan = plan
        UserDefaults.standard.set(true, forKey: dinerKey)
        UserDefaults.standard.set(plan.rawValue, forKey: dinerPlanKey)
    }

    func cancelDinerSubscription() {
        isDinerSubscribed = false
        dinerPlan = nil
        UserDefaults.standard.set(false, forKey: dinerKey)
        UserDefaults.standard.removeObject(forKey: dinerPlanKey)
    }

    func subscribeOwner(to plan: SubscriptionPlan) {
        isOwnerSubscribed = true
        ownerPlan = plan
        UserDefaults.standard.set(true, forKey: ownerKey)
        UserDefaults.standard.set(plan.rawValue, forKey: ownerPlanKey)
    }

    func cancelOwnerSubscription() {
        isOwnerSubscribed = false
        ownerPlan = nil
        UserDefaults.standard.set(false, forKey: ownerKey)
        UserDefaults.standard.removeObject(forKey: ownerPlanKey)
    }

    // MARK: - Cards (UI only - never sent anywhere, no real validation)

    func addCard(cardholderName: String, cardNumber: String, expiry: String) {
        let digitsOnly = cardNumber.filter(\.isNumber)
        let last4 = String(digitsOnly.suffix(4))
        let brand = Self.detectBrand(from: digitsOnly)
        savedCards.append(SavedCard(cardholderName: cardholderName, last4: last4, expiry: expiry, brand: brand))
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
