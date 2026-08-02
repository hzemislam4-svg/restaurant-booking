//
//  Theme.swift
//  RestaurantBooking
//
//  Central design tokens. Dark theme with Tajawal font, matching the
//  original design file (حجز المطاعم).
//

import SwiftUI

enum AppColor {
    static let accent = Color(hex: "d9614f")          // tomato accent
    static let accentSoft = Color(hex: "fbeae7")
    static let accentDim = Color(hex: "eba997")

    static let background = Color(hex: "161826")
    static let secondaryBackground = Color(hex: "232d40")
    static let cardBackground = Color(hex: "1c2433")

    static let textPrimary = Color(hex: "e9e9ed")
    static let textSecondary = Color(hex: "a9b0c3")
    static let textTertiary = Color(hex: "6d7488")
    static let textMuted = Color(hex: "5c6272")

    static let gold = Color(hex: "d99a5c")
    static let success = Color(hex: "6fae8f")
    static let danger = Color(hex: "d9614f")
    static let purple = Color(hex: "9184d9")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

enum AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

enum AppRadius {
    static let sm: CGFloat = 10
    static let md: CGFloat = 16
    static let lg: CGFloat = 22
    static let pill: CGFloat = 999
}

extension Font {
    static func appFont(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let name: String
        switch weight {
        case .bold, .heavy, .black:
            name = "Tajawal-Bold"
        case .medium, .semibold:
            name = "Tajawal-Medium"
        default:
            name = "Tajawal-Regular"
        }
        return Font.custom(name, size: size)
    }

    static func appFont(_ size: CGFloat, relativeTo style: Font.TextStyle) -> Font {
        Font.custom("Tajawal-Regular", size: size, relativeTo: style)
    }

    static let displayTitle = Font.appFont(30, weight: .bold)
    static let sectionTitle = Font.appFont(20, weight: .bold)
    static let cardTitle = Font.appFont(17, weight: .semibold)
    static let bodyText = Font.appFont(15)
    static let caption = Font.appFont(12, weight: .medium)
}
