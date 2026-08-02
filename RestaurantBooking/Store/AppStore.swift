//
//  AppStore.swift
//  RestaurantBooking
//
//  Single source of truth for the app's mutable state. Persists to
//  UserDefaults as JSON - no backend, no login required to use it.
//

import Foundation
import Combine

@MainActor
final class AppStore: ObservableObject {
    @Published private(set) var restaurants: [Restaurant] = SampleData.restaurants
    @Published private(set) var favoriteIds: Set<UUID> = []
    @Published private(set) var reservations: [Reservation] = []

    private let favoritesKey = "favoriteRestaurantIds"
    private let reservationsKey = "reservations"

    init() {
        loadFavorites()
        loadReservations()
    }

    // MARK: - Favorites

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

    var favoriteRestaurants: [Restaurant] {
        restaurants.filter { favoriteIds.contains($0.id) }
    }

    private func saveFavorites() {
        let array = Array(favoriteIds).map { $0.uuidString }
        UserDefaults.standard.set(array, forKey: favoritesKey)
    }

    private func loadFavorites() {
        guard let array = UserDefaults.standard.array(forKey: favoritesKey) as? [String] else { return }
        favoriteIds = Set(array.compactMap { UUID(uuidString: $0) })
    }

    // MARK: - Reservations

    func addReservation(_ reservation: Reservation) {
        reservations.append(reservation)
        reservations.sort { $0.date < $1.date }
        saveReservations()
    }

    func cancelReservation(_ reservation: Reservation) {
        guard let index = reservations.firstIndex(where: { $0.id == reservation.id }) else { return }
        reservations[index].status = .cancelled
        saveReservations()
    }

    var upcomingReservations: [Reservation] {
        reservations.filter { $0.status == .upcoming && $0.date >= Date() }
    }

    var pastReservations: [Reservation] {
        reservations.filter { $0.status != .upcoming || $0.date < Date() }
    }

    private func saveReservations() {
        guard let data = try? JSONEncoder().encode(reservations) else { return }
        UserDefaults.standard.set(data, forKey: reservationsKey)
    }

    private func loadReservations() {
        guard
            let data = UserDefaults.standard.data(forKey: reservationsKey),
            let decoded = try? JSONDecoder().decode([Reservation].self, from: data)
        else { return }
        reservations = decoded
    }

    // MARK: - Lookup

    func restaurant(for id: UUID) -> Restaurant? {
        restaurants.first { $0.id == id }
    }
}
