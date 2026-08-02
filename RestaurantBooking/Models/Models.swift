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

    var id: String { rawValue }

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
        }
    }

    var arabicName: String {
        switch self {
        case .italian: return "إيطالي"
        case .japanese: return "ياباني"
        case .moroccan: return "مغربي"
        case .lebanese: return "لبناني"
        case .french: return "فرنسي"
        case .seafood: return "مأكولات بحرية"
        case .steakhouse: return "مطاعم ستيك"
        case .cafe: return "مقهى"
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

struct Restaurant: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let cuisine: Cuisine
    let priceTier: PriceTier
    let rating: Double
    let reviewCount: Int
    let heroImageName: String
    let neighborhood: String
    let address: String
    let latitude: Double
    let longitude: Double
    let description: String
    let highlights: [String]
    let openingTime: String
    let closingTime: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(
        id: UUID = UUID(),
        name: String,
        cuisine: Cuisine,
        priceTier: PriceTier,
        rating: Double,
        reviewCount: Int,
        heroImageName: String,
        neighborhood: String,
        address: String,
        latitude: Double,
        longitude: Double,
        description: String,
        highlights: [String],
        openingTime: String,
        closingTime: String
    ) {
        self.id = id
        self.name = name
        self.cuisine = cuisine
        self.priceTier = priceTier
        self.rating = rating
        self.reviewCount = reviewCount
        self.heroImageName = heroImageName
        self.neighborhood = neighborhood
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
        self.highlights = highlights
        self.openingTime = openingTime
        self.closingTime = closingTime
    }
}

enum ReservationStatus: String, Codable {
    case upcoming
    case completed
    case cancelled
}

struct Reservation: Identifiable, Codable, Hashable {
    let id: UUID
    let restaurantId: UUID
    let restaurantName: String
    let date: Date
    let partySize: Int
    let specialRequest: String
    var status: ReservationStatus

    init(
        id: UUID = UUID(),
        restaurantId: UUID,
        restaurantName: String,
        date: Date,
        partySize: Int,
        specialRequest: String = "",
        status: ReservationStatus = .upcoming
    ) {
        self.id = id
        self.restaurantId = restaurantId
        self.restaurantName = restaurantName
        self.date = date
        self.partySize = partySize
        self.specialRequest = specialRequest
        self.status = status
    }
}
