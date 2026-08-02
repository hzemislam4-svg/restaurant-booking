import SwiftUI
import Foundation

struct Review: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let stars: Int
    let comment: String
    let date: String

    var initial: String { String(name.prefix(1)) }
    var starsStr: String {
        String(repeating: "★", count: stars) + String(repeating: "☆", count: 5 - stars)
    }
}

struct TableSeat: Identifiable, Hashable {
    let id: String
    let x: Double
    let y: Double
    let seats: Int
    let status: TableStatus

    var circleSize: CGFloat { 30 + CGFloat(seats) * 4 }
}

enum TableStatus: String {
    case available = "متاح"
    case reserved = "محجوز"
}

struct Booking: Identifiable, Hashable {
    let id: String
    let restaurantName: String
    let date: String
    let time: String
    let guests: Int
    let tableSeats: Int
    var status: BookingStatus

    var statusLabel: String {
        switch status {
        case .upcoming: return "قادم"
        case .cancelled: return "ملغي"
        }
    }
}

enum BookingStatus: String {
    case upcoming = "قادم"
    case cancelled = "ملغي"
}

struct Plan: Identifiable, Hashable {
    let id: String
    let label: String
    let price: String
    let period: String
    let badge: String?
}

struct UserProfile: Hashable {
    var name: String
    var phone: String
    var email: String
    var isPremium: Bool
    var premiumSince: Date?
    var accentTheme: String

    var initial: String { String(name.prefix(1)) }

    var membershipLabel: String { isPremium ? "عضو مميز" : "عضوية مجانية" }
}

struct Reservation: Identifiable, Hashable {
    let id = UUID()
    let restaurant: Restaurant
    let date: Date
    let time: String
    let guests: Int
    let tableSeats: Int
}
