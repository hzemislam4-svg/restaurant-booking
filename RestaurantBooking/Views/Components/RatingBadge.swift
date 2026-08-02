//
//  RatingBadge.swift
//  RestaurantBooking
//

import SwiftUI

struct RatingBadge: View {
    let rating: Double
    let reviewCount: Int?
    var compact: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: compact ? 10 : 12))
                .foregroundStyle(AppColor.gold)
            Text(String(format: "%.1f", rating))
                .font(compact ? .caption : .subheadline.weight(.semibold))
                .foregroundStyle(AppColor.textPrimary)
            if let reviewCount, !compact {
                Text("(\(reviewCount))")
                    .font(.caption)
                    .foregroundStyle(AppColor.textSecondary)
            }
        }
    }
}
