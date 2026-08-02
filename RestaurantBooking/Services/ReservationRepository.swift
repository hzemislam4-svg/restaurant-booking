//
//  ReservationRepository.swift
//  RestaurantBooking
//
//  Firestore-backed reservations, scoped to the signed-in customer via
//  a live listener - so "My Reservations" and cancelling actually
//  persists to the cloud and shows up again after reinstalling the app
//  or switching devices, unlike the old UserDefaults version.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ReservationRepository: ObservableObject {
    @Published private(set) var reservations: [Reservation] = []
    @Published var errorMessage: String?

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func startListening(forCustomer customerId: String) {
        listener?.remove()
        listener = db.collection("reservations")
            .whereField("customerId", isEqualTo: customerId)
            .order(by: "date", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }
                if let error {
                    Task { @MainActor in self.errorMessage = error.localizedDescription }
                    return
                }
                let docs = snapshot?.documents ?? []
                let parsed = docs.compactMap { try? $0.data(as: Reservation.self) }
                Task { @MainActor in self.reservations = parsed }
            }
    }

    func stopListening() {
        listener?.remove()
        reservations = []
    }

    func addReservation(_ reservation: Reservation) async throws {
        try db.collection("reservations").document(reservation.id).setData(from: reservation)
    }

    /// This is the actual, working cancel path - updates the shared
    /// Firestore document so the change is real and permanent, not just
    /// a local array mutation that disappears if the app is reinstalled.
    func cancelReservation(_ reservation: Reservation) async throws {
        try await db.collection("reservations").document(reservation.id)
            .updateData(["status": ReservationStatus.cancelled.rawValue])
    }

    var upcomingReservations: [Reservation] {
        reservations.filter { $0.status == .upcoming && $0.date >= Date() }
    }

    var pastReservations: [Reservation] {
        reservations.filter { $0.status != .upcoming || $0.date < Date() }
    }
}
