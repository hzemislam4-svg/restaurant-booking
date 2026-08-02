//
//  PreviewFixtures.swift
//  RestaurantBooking
//
//  A single hardcoded Restaurant used only by #Preview blocks in Xcode
//  canvases. This is NOT loaded into the running app - the app always
//  starts empty and gets its data from Firestore. Safe to delete if
//  you don't use SwiftUI previews.
//

import Foundation

enum PreviewFixtures {
    static let restaurant = Restaurant(
        ownerId: "preview-owner",
        name: "Villa Rosetta",
        cuisine: .italian,
        priceTier: .upscale,
        rating: 4.8,
        reviewCount: 612,
        neighborhood: "Downtown",
        address: "12 Vine Street",
        latitude: 36.7538,
        longitude: 3.0588,
        description: "Handmade pasta and wood-fired classics in a warm, candlelit dining room.",
        highlights: ["Handmade pasta", "Extensive wine list", "Romantic ambiance"],
        openingTime: "12:00 PM",
        closingTime: "11:00 PM"
    )
}
