//
//  SessionStore.swift
//  RestaurantBooking
//
//  Ultra-light local login: just a display name and a role, no
//  email/password. The uid is derived from name+role so reservations
//  and restaurants keep working against Firestore across launches.
//

import Foundation

struct AppUser: Codable {
    let uid: String
    var displayName: String
    var role: UserRole
    let createdAt: Date
}

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var currentUser: AppUser?

    private let storageKey = "session.currentUser"

    var isLoggedIn: Bool { currentUser != nil }

    init() {
        restore()
    }

    func logIn(name: String, role: UserRole) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let uid = Self.makeUID(name: trimmed, role: role)
        let user = AppUser(uid: uid, displayName: trimmed, role: role, createdAt: Date())
        currentUser = user
        persist()
    }

    func logOut() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    // MARK: - Private

    private func persist() {
        guard let user = currentUser,
              let data = try? JSONEncoder().encode(user) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func restore() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let user = try? JSONDecoder().decode(AppUser.self, from: data) else { return }
        currentUser = user
    }

    /// Stable uid from name+role so the same person keeps their data.
    private static func makeUID(name: String, role: UserRole) -> String {
        let base = "\(name.lowercased())-\(role.rawValue)"
        var hash: UInt64 = 14695981039346656037
        for byte in base.utf8 {
            hash ^= UInt64(byte)
            hash &*= 1099511628211
        }
        return String(format: "local-%016llx", hash)
    }
}
