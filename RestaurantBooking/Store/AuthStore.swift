//
//  AuthStore.swift
//  RestaurantBooking
//
//  Simple local account system. No backend, no network call - the
//  "account" lives entirely on this device in UserDefaults.
//
//  IMPORTANT (be upfront with yourself about this): storing accounts
//  locally like this is fine for a personal/demo app, but it is NOT how
//  a real multi-device product should handle auth - there's no server,
//  so a reinstall wipes every account, and two different people using
//  the app on two different phones can register the exact same
//  username with different passwords with no conflict detection.
//  Passwords are hashed (SHA256 + per-user salt) before being stored,
//  so at least a raw look at UserDefaults won't reveal the plaintext.
//

import Foundation
import CryptoKit
import Combine

struct StoredAccount: Codable {
    let username: String
    let salt: String
    let passwordHash: String
    let displayName: String
    let createdAt: Date
}

@MainActor
final class AuthStore: ObservableObject {
    @Published private(set) var currentUsername: String?
    @Published var errorMessage: String?

    private let accountsKey = "storedAccounts"
    private let sessionKey = "currentSessionUsername"

    var isLoggedIn: Bool { currentUsername != nil }

    var currentDisplayName: String {
        guard let username = currentUsername, let account = loadAccounts()[username] else {
            return "ضيف"
        }
        return account.displayName
    }

    init() {
        currentUsername = UserDefaults.standard.string(forKey: sessionKey)
    }

    // MARK: - Sign up

    func signUp(displayName: String, username: String, password: String) -> Bool {
        errorMessage = nil
        let normalizedUsername = username.trimmingCharacters(in: .whitespaces).lowercased()

        guard !normalizedUsername.isEmpty, !password.isEmpty, !displayName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "يرجى ملء جميع الحقول."
            return false
        }
        guard password.count >= 4 else {
            errorMessage = "كلمة المرور يجب أن تكون 4 أحرف على الأقل."
            return false
        }

        var accounts = loadAccounts()
        guard accounts[normalizedUsername] == nil else {
            errorMessage = "اسم المستخدم هذا مستخدم بالفعل."
            return false
        }

        let salt = UUID().uuidString
        let account = StoredAccount(
            username: normalizedUsername,
            salt: salt,
            passwordHash: Self.hash(password: password, salt: salt),
            displayName: displayName.trimmingCharacters(in: .whitespaces),
            createdAt: Date()
        )
        accounts[normalizedUsername] = account
        saveAccounts(accounts)

        signIn(username: normalizedUsername)
        return true
    }

    // MARK: - Sign in

    func logIn(username: String, password: String) -> Bool {
        errorMessage = nil
        let normalizedUsername = username.trimmingCharacters(in: .whitespaces).lowercased()

        guard let account = loadAccounts()[normalizedUsername] else {
            errorMessage = "لا يوجد حساب بهذا الاسم."
            return false
        }
        let hash = Self.hash(password: password, salt: account.salt)
        guard hash == account.passwordHash else {
            errorMessage = "كلمة المرور غير صحيحة."
            return false
        }

        signIn(username: normalizedUsername)
        return true
    }

    func logOut() {
        currentUsername = nil
        UserDefaults.standard.removeObject(forKey: sessionKey)
    }

    // MARK: - Private

    private func signIn(username: String) {
        currentUsername = username
        UserDefaults.standard.set(username, forKey: sessionKey)
    }

    private func loadAccounts() -> [String: StoredAccount] {
        guard
            let data = UserDefaults.standard.data(forKey: accountsKey),
            let decoded = try? JSONDecoder().decode([String: StoredAccount].self, from: data)
        else { return [:] }
        return decoded
    }

    private func saveAccounts(_ accounts: [String: StoredAccount]) {
        guard let data = try? JSONEncoder().encode(accounts) else { return }
        UserDefaults.standard.set(data, forKey: accountsKey)
    }

    private static func hash(password: String, salt: String) -> String {
        let combined = salt + password
        let digest = SHA256.hash(data: Data(combined.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
