//
//  RestaurantImagePlaceholder.swift
//  RestaurantBooking
//
//  Renders a tasteful gradient + cuisine icon instead of a real photo.
//  Swap this out for Image(restaurant.heroImageName) once you add real
//  photos to Assets.xcassets - the name is already on the model.
//

import SwiftUI

struct RestaurantImagePlaceholder: View {
    let cuisine: Cuisine
    var cornerRadius: CGFloat = AppRadius.md

    private var gradient: LinearGradient {
        let palette: [Cuisine: [Color]] = [
            .italian: [Color(red: 0.75, green: 0.20, blue: 0.20), Color(red: 0.42, green: 0.09, blue: 0.09)],
            .japanese: [Color(red: 0.15, green: 0.18, blue: 0.22), Color(red: 0.05, green: 0.06, blue: 0.09)],
            .moroccan: [Color(red: 0.82, green: 0.50, blue: 0.15), Color(red: 0.55, green: 0.28, blue: 0.08)],
            .lebanese: [Color(red: 0.35, green: 0.55, blue: 0.35), Color(red: 0.15, green: 0.30, blue: 0.18)],
            .french: [Color(red: 0.25, green: 0.30, blue: 0.55), Color(red: 0.10, green: 0.12, blue: 0.28)],
            .seafood: [Color(red: 0.15, green: 0.45, blue: 0.60), Color(red: 0.05, green: 0.20, blue: 0.32)],
            .steakhouse: [Color(red: 0.40, green: 0.20, blue: 0.15), Color(red: 0.18, green: 0.08, blue: 0.06)],
            .cafe: [Color(red: 0.60, green: 0.42, blue: 0.28), Color(red: 0.35, green: 0.22, blue: 0.14)],
        ]
        let colors = palette[cuisine] ?? [AppColor.accent, AppColor.accent.opacity(0.6)]
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var body: some View {
        ZStack {
            gradient
            Text(cuisine.icon)
                .font(.system(size: 40))
                .opacity(0.9)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
