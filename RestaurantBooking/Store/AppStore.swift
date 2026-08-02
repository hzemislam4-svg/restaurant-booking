//
//  AppStore.swift
//  RestaurantBooking
//
//  Favorites only now - restaurants live in RestaurantRepository
//  (Firestore) and reservations live in ReservationRepository
//  (Firestore). Favorites stay local UserDefaults on purpose: they're
//  a personal, low-stakes preference, not something that needs to be
//  visible to anyone else, so there's no real benefit to spending
//  Firestore read/write quota on them.
//

import Foundation
import Combine

@MainActor
final class AppStore: ObservableObject {
    @Published private(set) var favoriteIds: Set<String> = []

    private let favoritesKey = "favoriteRestaurantIds"

    init() {
        loadFavorites()
    }

    func isFavorite(_ restaurant: Restaurant) -> Bool {
        favoriteIds.contains(restaurant.id)
    }

    func toggleFavorite(_ restaurant: Restaurant) {
        if favoriteIds.contains(restaurant.id) {
            favoriteIds.remove(restaurant.id)
        } else {
            favoriteIds.insert(restaurant.id)
        }
        saveFavorites()
    }

    func favoriteRestaurants(from all: [Restaurant]) -> [Restaurant] {
        all.filter { favoriteIds.contains($0.id) }
    }

    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteIds), forKey: favoritesKey)
    }

    private func loadFavorites() {
        guard let array = UserDefaults.standard.array(forKey: favoritesKey) as? [String] else { return }
        favoriteIds = Set(array)
    }
}
