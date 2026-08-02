//
//  RestaurantPhotoView.swift
//  RestaurantBooking
//
//  Shows the first real photo uploaded by the owner (from Firestore
//  imageURLs) via AsyncImage, falling back to the gradient placeholder
//  until the owner has uploaded at least one photo.
//

import SwiftUI

struct RestaurantPhotoView: View {
    let restaurant: Restaurant
    var cornerRadius: CGFloat = AppRadius.md

    var body: some View {
        Group {
            if let firstURL = restaurant.imageURLs.first, let url = URL(string: firstURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        RestaurantImagePlaceholder(cuisine: restaurant.cuisine, cornerRadius: cornerRadius)
                    default:
                        ZStack {
                            AppColor.cardBackground
                            ProgressView()
                        }
                    }
                }
            } else {
                RestaurantImagePlaceholder(cuisine: restaurant.cuisine, cornerRadius: cornerRadius)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
