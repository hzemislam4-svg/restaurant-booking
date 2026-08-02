//
//  RestaurantBookingApp.swift
//  RestaurantBooking
//
//  App entry point. Configures Firebase and wires up every store/
//  repository as an environment object.
//

import SwiftUI
import FirebaseCore

@main
struct RestaurantBookingApp: App {
    @StateObject private var favoritesStore = AppStore()
    @StateObject private var auth = FirebaseAuthService()
    @StateObject private var subscriptions = SubscriptionStore()
    @StateObject private var restaurantRepo = RestaurantRepository()
    @StateObject private var reservationRepo = ReservationRepository()

    init() {
        FirebaseApp.configure()
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if auth.isLoggedIn {
                    RootTabView()
                        .onAppear {
                            if let uid = auth.currentUser?.uid {
                                reservationRepo.startListening(forCustomer: uid)
                            }
                        }
                        .onChange(of: auth.currentUser?.uid) { _, newUid in
                            if let newUid {
                                reservationRepo.startListening(forCustomer: newUid)
                            } else {
                                reservationRepo.stopListening()
                            }
                        }
                } else {
                    SignInView()
                }
            }
            .environmentObject(favoritesStore)
            .environmentObject(auth)
            .environmentObject(subscriptions)
            .environmentObject(restaurantRepo)
            .environmentObject(reservationRepo)
            .environment(\.layoutDirection, .rightToLeft)
            .preferredColorScheme(.dark)
            .animation(.easeInOut, value: auth.isLoggedIn)
        }
    }
}
