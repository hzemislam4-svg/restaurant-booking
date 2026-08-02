//
//  RestaurantBookingApp.swift
//  RestaurantBooking
//
//  App entry point.
//

import SwiftUI

@main
struct RestaurantBookingApp: App {
    @StateObject private var store = AppStore()
    @StateObject private var auth = AuthStore()
    @StateObject private var subscriptions = SubscriptionStore()

    init() {
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
                } else {
                    SignInView()
                }
            }
            .environmentObject(store)
            .environmentObject(auth)
            .environmentObject(subscriptions)
            .environment(\.layoutDirection, .rightToLeft)
            .preferredColorScheme(.dark)
            .animation(.easeInOut, value: auth.isLoggedIn)
        }
    }
}
