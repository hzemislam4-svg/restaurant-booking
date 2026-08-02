import SwiftUI
import Foundation
import Combine

enum Screen: Hashable {
    case home, map, bookings, favorites
}

enum Flow: Hashable {
    case detail(Restaurant)
    case booking(Restaurant)
    case tableSelection(Restaurant)
    case confirmation(Restaurant)
    case payment(Plan)
    case account
    case membership
}

final class AppStore: ObservableObject {
    @Published var tab: Screen = .home
    @Published var flow: Flow?
    @Published var favorites: Set<String> = []
    @Published var search: String = ""
    @Published var cuisineFilter: String = "الكل"
    @Published var homeLayout: HomeLayout = .grid

    @Published var selectedDate: Date = Date()
    @Published var selectedTime: String? = nil
    @Published var guests: Int = 2
    @Published var selectedTable: TableSeat? = nil

    @Published var bookings: [Booking] = []
    @Published var isLoggedIn: Bool = false
    @Published var user: UserProfile = UserProfile(name: "", phone: "", email: "", isPremium: false, premiumSince: nil, accentTheme: "tomato")
    @Published var selectedPlan: String = "yearly"
    @Published var mapPreviewRestaurant: Restaurant?

    var accentColor: Color {
        guard let theme = AccentTheme(rawValue: user.accentTheme) else { return Theme.accent }
        return theme.color
    }

    var filteredRestaurants: [Restaurant] {
        let q = search.trimmingCharacters(in: .whitespaces)
        return MockData.restaurants.filter { r in
            let matchesSearch = q.isEmpty || r.name.contains(q) || r.cuisine.contains(q)
            let matchesCuisine = cuisineFilter == "الكل" || r.cuisine == cuisineFilter
            return matchesSearch && matchesCuisine
        }
    }

    var favoritesList: [Restaurant] {
        MockData.restaurants.filter { favorites.contains($0.id) }
    }

    func toggleFavorite(_ restaurant: Restaurant) {
        if favorites.contains(restaurant.id) {
            favorites.remove(restaurant.id)
        } else {
            favorites.insert(restaurant.id)
        }
    }

    func isFavorite(_ restaurant: Restaurant) -> Bool {
        favorites.contains(restaurant.id)
    }

    var bookingsUpcomingFirst: [Booking] {
        bookings.sorted { lhs, rhs in
            if lhs.status != rhs.status { return lhs.status == .upcoming }
            return lhs.date > rhs.date
        }
    }

    func addBooking(_ booking: Booking) {
        bookings.insert(booking, at: 0)
    }

    func cancelBooking(_ id: String) {
        if let idx = bookings.firstIndex(where: { $0.id == id }) {
            bookings[idx].status = .cancelled
        }
    }

    func loginDemo() {
        isLoggedIn = true
        user = UserProfile(name: "عبدالله القحطاني", phone: "05xxxxxxxx", email: "", isPremium: false, premiumSince: nil, accentTheme: "tomato")
    }

    func loginWithGoogle(profile: UserProfile) {
        isLoggedIn = true
        user = profile
    }

    func logout() {
        isLoggedIn = false
        user = UserProfile(name: "", phone: "", email: "", isPremium: false, premiumSince: nil, accentTheme: "tomato")
        GoogleAuthManager.shared.signOut()
    }

    func subscribe(to plan: Plan) {
        user.isPremium = true
        user.premiumSince = Date()
    }
}

enum HomeLayout: String, CaseIterable {
    case grid = "شبكة"
    case list = "قائمة"
    case featured = "مميز"
}
