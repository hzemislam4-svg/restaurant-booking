//
//  RootTabView.swift
//  RestaurantBooking
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            DiscoverView()
                .tabItem { Label("اكتشف", systemImage: "sparkles") }

            FavoritesView()
                .tabItem { Label("المفضلة", systemImage: "heart.fill") }

            BookingsView()
                .tabItem { Label("الحجوزات", systemImage: "calendar") }

            ProfileView()
                .tabItem { Label("الملف الشخصي", systemImage: "person.crop.circle") }
        }
        .tint(AppColor.accent)
    }
}

#Preview {
    RootTabView()
        .environmentObject(AppStore())
        .environmentObject(FirebaseAuthService())
        .environmentObject(SubscriptionStore())
        .environmentObject(RestaurantRepository())
        .environmentObject(ReservationRepository())
}
