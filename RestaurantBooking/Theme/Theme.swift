import SwiftUI

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
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

enum Theme {
    // ألوان التصميم الأساسية
    static let background = Color(hex: "161826")
    static let surface = Color(hex: "1c2433")
    static let surfaceAlt = Color(hex: "232d40")
    static let divider = Color.white.opacity(0.12)
    static let textPrimary = Color(hex: "e9e9ed")
    static let textSecondary = Color.white.opacity(0.6)
    static let textMuted = Color.white.opacity(0.45)

    // أكسنت افتراضي (طماطمي) - يتبدل من الحساب
    static let accent = Color(hex: "d9614f")
    static let accentSoft = Color(hex: "fbeae7")
    static let accentDim = Color(hex: "eba997")

    // أكسنت بديلة
    static let amber = Color(hex: "d99a5c")
    static let olive = Color(hex: "93a35c")
    static let purple = Color(hex: "9184d9")

    static let success = Color(hex: "6fae8f")
    static let danger = Color(hex: "d9614f")
    static let reserved = Color(hex: "e9e9ed")

    static let card = Color(hex: "1c2433")

    static let tabBarBackground = Color.black.opacity(0.55)
    static let tabBarBorder = Color.white.opacity(0.14)

    // الخط
    static let fontName = "Tajawal"

    static let radiusLg: CGFloat = 16
    static let radiusMd: CGFloat = 12
    static let radiusSm: CGFloat = 10
}

enum AccentTheme: String, CaseIterable, Identifiable {
    case tomato = "طماطمي"
    case amber = "كهرماني"
    case olive = "زيتوني"
    case purple = "بنفسجي"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .tomato: return Theme.accent
        case .amber: return Theme.amber
        case .olive: return Theme.olive
        case .purple: return Theme.purple
        }
    }
}
