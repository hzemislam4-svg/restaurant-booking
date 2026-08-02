//
//  RestaurantRepository.swift
//  RestaurantBooking
//
//  Firestore-backed restaurant list. This is the piece that makes a
//  restaurant an owner adds on their phone visible to every other
//  customer's phone - a live snapshot listener keeps everyone's local
//  `restaurants` array in sync with the shared cloud collection.
//
//  Firestore free (Spark) tier limits: 1 GiB stored, 50K reads/day,
//  20K writes/day, 20K deletes/day - more than enough for testing and
//  early real usage with no billing account attached.
//

import Foundation
import FirebaseFirestore

@MainActor
final class RestaurantRepository: ObservableObject {
    @Published private(set) var restaurants: [Restaurant] = []
    @Published var errorMessage: String?

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    init() {
        startListening()
    }

    deinit {
        listener?.remove()
    }

    private func startListening() {
        listener = db.collection("restaurants")
            .whereField("isPublished", isEqualTo: true)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }
                if let error {
                    Task { @MainActor in self.errorMessage = error.localizedDescription }
                    return
                }
                let docs = snapshot?.documents ?? []
                let parsed = docs.compactMap { try? $0.data(as: Restaurant.self) }
                Task { @MainActor in self.restaurants = parsed }
            }
    }

    // MARK: - Owner actions

    func createRestaurant(_ restaurant: Restaurant) async throws {
        try db.collection("restaurants").document(restaurant.id).setData(from: restaurant)
    }

    func updateRestaurant(_ restaurant: Restaurant) async throws {
        try db.collection("restaurants").document(restaurant.id).setData(from: restaurant, merge: true)
    }

    func deleteRestaurant(_ restaurant: Restaurant) async throws {
        try await db.collection("restaurants").document(restaurant.id).delete()
    }

    /// Restaurants owned by the current user, for the "My Restaurant"
    /// management screen. Filters the already-synced local array rather
    /// than firing a second query.
    func restaurants(ownedBy ownerId: String) -> [Restaurant] {
        restaurants.filter { $0.ownerId == ownerId }
    }

    func restaurant(for id: String) -> Restaurant? {
        restaurants.first { $0.id == id }
    }
}
