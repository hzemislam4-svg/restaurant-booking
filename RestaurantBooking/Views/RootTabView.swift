//
//  RootTabView.swift
//  RestaurantBooking
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            DiscoverView()
                .tabItem { Label("الاستكشاف", systemImage: "sparkles") }

            FavoritesView()
                .tabItem { Label("المفضلة", systemImage: "heart.fill") }

            BookingsView()
                .tabItem { Label("حجوزاتي", systemImage: "calendar") }

            ProfileView()
                .tabItem { Label("الملف", systemImage: "person.crop.circle") }
        }
        .tint(AppColor.accent)
    }
}

#Preview {
    RootTabView()
        .environmentObject(AppStore())
}
