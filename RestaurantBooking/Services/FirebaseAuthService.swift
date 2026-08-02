//
//  FirebaseAuthService.swift
//  RestaurantBooking
//
//  Wraps Firebase Auth (email/password only - fully free on the Spark
//  plan, no billing account required, unlike Phone Auth's SMS quota
//  which needs Blaze). Add the Firebase SDK first:
//
//  Xcode -> File -> Add Package Dependencies ->
//  https://github.com/firebase/firebase-ios-sdk
//  Select: FirebaseAuth, FirebaseFirestore, FirebaseStorage
//
//  Then drop your GoogleService-Info.plist (downloaded from the
//  Firebase Console) into the project root - that's what tells the SDK
//  which free Firebase project to talk to.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AppUser: Codable {
    let uid: String
    var displayName: String
    var role: UserRole
    let createdAt: Date
}

@MainActor
final class FirebaseAuthService: ObservableObject {
    @Published var currentUser: AppUser?
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let db = Firestore.firestore()
    private var authListenerHandle: AuthStateDidChangeListenerHandle?

    var isLoggedIn: Bool { currentUser != nil }

    init() {
        authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            guard let self else { return }
            Task { @MainActor in
                if let firebaseUser {
                    await self.loadProfile(uid: firebaseUser.uid)
                } else {
                    self.currentUser = nil
                }
            }
        }
    }

    deinit {
        if let handle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: - Sign up

    func signUp(displayName: String, email: String, password: String, role: UserRole) async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        guard !displayName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "يرجى إدخال اسمك."
            return
        }
        guard password.count >= 6 else {
            errorMessage = "كلمة المرور يجب أن تكون 6 أحرف على الأقل (الحد الأدنى في Firebase)."
            return
        }

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = AppUser(uid: result.user.uid, displayName: displayName, role: role, createdAt: Date())
            try db.collection("users").document(user.uid).setData(from: user)
            currentUser = user
        } catch {
            errorMessage = Self.friendlyMessage(for: error)
        }
    }

    // MARK: - Sign in

    func logIn(email: String, password: String) async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            await loadProfile(uid: result.user.uid)
        } catch {
            errorMessage = Self.friendlyMessage(for: error)
        }
    }

    func logOut() {
        try? Auth.auth().signOut()
        currentUser = nil
    }

    /// Lets a diner become a restaurant owner (or vice versa) later,
    /// e.g. right before showing the owner subscription paywall.
    func updateRole(_ role: UserRole) async {
        guard var user = currentUser else { return }
        user.role = role
        do {
            try db.collection("users").document(user.uid).setData(from: user, merge: true)
            currentUser = user
        } catch {
            errorMessage = Self.friendlyMessage(for: error)
        }
    }

    // MARK: - Private

    private func loadProfile(uid: String) async {
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument()
            currentUser = try snapshot.data(as: AppUser.self)
        } catch {
            errorMessage = "تعذر تحميل ملفك الشخصي. حاول تسجيل الدخول مجدداً."
        }
    }

    private static func friendlyMessage(for error: Error) -> String {
        let nsError = error as NSError
        switch AuthErrorCode(rawValue: nsError.code) {
        case .emailAlreadyInUse: return "هذا البريد الإلكتروني مسجّل بالفعل."
        case .invalidEmail: return "عنوان البريد الإلكتروني غير صحيح."
        case .weakPassword: return "يرجى اختيار كلمة مرور أقوى."
        case .wrongPassword, .userNotFound: return "البريد الإلكتروني أو كلمة المرور غير صحيحة."
        case .networkError: return "لا يوجد اتصال بالإنترنت."
        default: return error.localizedDescription
        }
    }
}
