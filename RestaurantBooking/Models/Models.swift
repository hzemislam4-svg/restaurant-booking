//
//  Models.swift
//  RestaurantBooking
//

import Foundation
import CoreLocation

enum Cuisine: String, CaseIterable, Codable, Identifiable {
    case italian = "Italian"
    case japanese = "Japanese"
    case moroccan = "Moroccan"
    case lebanese = "Lebanese"
    case french = "French"
    case seafood = "Seafood"
    case steakhouse = "Steakhouse"
    case cafe = "Café"
    case other = "Other"

    var id: String { rawValue }

    var arabicName: String {
        switch self {
        case .italian: return "إيطالي"
        case .japanese: return "ياباني"
        case .moroccan: return "مغربي"
        case .lebanese: return "لبناني"
        case .french: return "فرنسي"
        case .seafood: return "مأكولات بحرية"
        case .steakhouse: return "ستيك"
        case .cafe: return "مقهى"
        case .other: return "أخرى"
        }
    }

    var icon: String {
        switch self {
        case .italian: return "🍝"
        case .japanese: return "🍣"
        case .moroccan: return "🍲"
        case .lebanese: return "🥙"
        case .french: return "🥐"
        case .seafood: return "🦞"
        case .steakhouse: return "🥩"
        case .cafe: return "☕️"
        case .other: return "🍽️"
        }
    }
}

enum PriceTier: Int, CaseIterable, Codable {
    case budget = 1
    case moderate = 2
    case upscale = 3
    case luxury = 4

    var symbol: String { String(repeating: "$", count: rawValue) }
}

enum UserRole: String, Codable {
    case diner
    case owner
}

/// A restaurant listing. Owner-created listings live in Firestore under
/// the "restaurants" collection so every user's app sees them - this is
/// the whole point of moving off local-only storage.
struct Restaurant: Identifiable, Codable, Hashable {
    var id: String
    let ownerId: String
    let name: String
    let cuisine: Cuisine
    let priceTier: PriceTier
    var rating: Double
    var reviewCount: Int
    var imageURLs: [String]
    let neighborhood: String
    let address: String
    let latitude: Double
    let longitude: Double
    let description: String
    let highlights: [String]
    let openingTime: String
    let closingTime: String
    let createdAt: Date
    var isPublished: Bool

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    /// True once the owner has uploaded at least one real photo. Until
    /// then, the UI falls back to the gradient placeholder so a listing
    /// never looks broken while the owner is still setting it up.
    var hasRealPhotos: Bool { !imageURLs.isEmpty }

    init(
        id: String = UUID().uuidString,
        ownerId: String,
        name: String,
        cuisine: Cuisine,
        priceTier: PriceTier,
        rating: Double = 0,
        reviewCount: Int = 0,
        imageURLs: [String] = [],
        neighborhood: String,
        address: String,
        latitude: Double,
        longitude: Double,
        description: String,
        highlights: [String],
        openingTime: String,
        closingTime: String,
        createdAt: Date = Date(),
        isPublished: Bool = true
    ) {
        self.id = id
        self.ownerId = ownerId
        self.name = name
        self.cuisine = cuisine
        self.priceTier = priceTier
        self.rating = rating
        self.reviewCount = reviewCount
        self.imageURLs = imageURLs
        self.neighborhood = neighborhood
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
        self.highlights = highlights
        self.openingTime = openingTime
        self.closingTime = closingTime
        self.createdAt = createdAt
        self.isPublished = isPublished
    }
}

enum ReservationStatus: String, Codable {
    case upcoming
    case completed
    case cancelled
}

/// A booking. Stored in Firestore under "reservations" so a customer's
/// upcoming reservations show up on any device they sign into, and (in
/// a future step) so the restaurant owner could see incoming bookings.
struct Reservation: Identifiable, Codable, Hashable {
    var id: String
    let restaurantId: String
    let restaurantName: String
    let customerId: String
    let date: Date
    let partySize: Int
    let specialRequest: String
    let contactName: String
    let contactPhone: String
    let confirmedIntent: Bool
    var status: ReservationStatus
    let createdAt: Date

    init(
        id: String = UUID().uuidString,
        restaurantId: String,
        restaurantName: String,
        customerId: String,
        date: Date,
        partySize: Int,
        specialRequest: String = "",
        contactName: String,
        contactPhone: String,
        confirmedIntent: Bool,
        status: ReservationStatus = .upcoming,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.restaurantId = restaurantId
        self.restaurantName = restaurantName
        self.customerId = customerId
        self.date = date
        self.partySize = partySize
        self.specialRequest = specialRequest
        self.contactName = contactName
        self.contactPhone = contactPhone
        self.confirmedIntent = confirmedIntent
        self.status = status
        self.createdAt = createdAt
    }
}
