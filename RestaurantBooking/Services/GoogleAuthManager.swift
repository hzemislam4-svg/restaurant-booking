import Foundation
import GoogleSignIn

final class GoogleAuthManager: ObservableObject {
    static let shared = GoogleAuthManager()

    @Published var currentUser: GIDGoogleUser?
    @Published var isSignedIn: Bool = false

    private var clientID: String? {
        Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String
    }

    var isConfigured: Bool {
        guard let cid = clientID, !cid.isEmpty,
              !cid.contains("restaurantbooking.apps.googleusercontent.com") else { return false }
        return true
    }

    private init() {
        if isConfigured, let cid = clientID {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: cid)
        }
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, _ in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isSignedIn = user != nil
            }
        }
    }

    func signIn(presenting: UIViewController, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard isConfigured else {
            completion(.success(UserProfile(name: "زائر تجريبي", phone: "05xxxxxxxx", email: "demo@restaurant.app", isPremium: false, premiumSince: nil, accentTheme: "tomato")))
            return
        }
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = result?.user, let profile = user.profile else {
                completion(.failure(NSError(domain: "GoogleAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "لم نتمكن من قراءة بيانات الحساب."])))
                return
            }
            DispatchQueue.main.async {
                self.currentUser = user
                self.isSignedIn = true
                completion(.success(UserProfile(
                    name: profile.name,
                    phone: "",
                    email: profile.email,
                    isPremium: false,
                    premiumSince: nil,
                    accentTheme: "tomato"
                )))
            }
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        currentUser = nil
        isSignedIn = false
    }

    func handleOpenURL(_ url: URL) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
