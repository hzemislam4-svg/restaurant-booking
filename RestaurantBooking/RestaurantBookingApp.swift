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

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(store)
                .environment(\.layoutDirection, .rightToLeft)
                .preferredColorScheme(.dark)
        }
    }
}
