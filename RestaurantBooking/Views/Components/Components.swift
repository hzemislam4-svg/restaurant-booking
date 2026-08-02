import SwiftUI

struct FoodPlaceholderImage: View {
    var title: String = ""
    var cornerRadius: CGFloat = 10

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(colors: [Theme.surface, Theme.surfaceAlt], startPoint: .topLeading, endPoint: .bottomTrailing)
                Circle()
                    .fill(Theme.accent.opacity(0.18))
                    .frame(width: geo.size.height * 0.55)
                    .offset(x: geo.size.width * 0.28, y: -geo.size.height * 0.28)
                Circle()
                    .fill(Theme.amber.opacity(0.12))
                    .frame(width: geo.size.height * 0.45)
                    .offset(x: -geo.size.width * 0.32, y: geo.size.height * 0.30)
                Image(systemName: "fork.knife")
                    .font(.system(size: geo.size.height * 0.28, weight: .semibold))
                    .foregroundStyle(Theme.accent.opacity(0.55))
            }
            .overlay {
                if !title.isEmpty {
                    Text(title)
                        .font(.appFont(9))
                        .foregroundStyle(Theme.textSecondary)
                        .padding(4)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding(6)
                }
            }
        }
    }
}

struct FavoriteButton: View {
    let isFavorite: Bool
    let action: () -> Void
    var circleBackground: Color = Color.black.opacity(0.45)

    var body: some View {
        Button(action: action) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(isFavorite ? Theme.danger : Theme.textPrimary)
                .frame(width: 30, height: 30)
                .background(circleBackground)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

struct TagView: View {
    let text: String
    var accent: Bool = false
    var outlined: Bool = false

    var body: some View {
        Text(text)
            .font(.appFont(11, relativeTo: .caption))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background {
                if accent {
                    Capsule().fill(Theme.accent.opacity(0.18))
                } else if outlined {
                    Capsule().stroke(Theme.divider)
                } else {
                    Capsule().fill(Color.white.opacity(0.08))
                }
            }
            .foregroundStyle(accent ? Theme.accent : Theme.textPrimary)
            .overlay {
                if outlined {
                    Capsule().stroke(Theme.divider)
                }
            }
    }
}

struct StarRatingView: View {
    let rating: Double

    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "star.fill")
                .font(.system(size: 11))
                .foregroundStyle(Theme.amber)
            Text(String(format: "%.1f", rating))
                .font(.appFont(12, weight: .medium))
                .foregroundStyle(Theme.accent)
        }
    }
}

struct ChipView: View {
    let label: String
    var selected: Bool = false
    var accentColor: Color = Theme.accent
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.appFont(12, weight: selected ? .medium : .regular))
                .foregroundStyle(selected ? accentColor : Theme.textPrimary)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule().fill(selected ? accentColor.opacity(0.15) : Color.white.opacity(0.05))
                )
                .overlay(
                    Capsule().stroke(selected ? accentColor.opacity(0.7) : Theme.divider)
                )
        }
        .buttonStyle(.plain)
    }
}

struct PrimaryButton: View {
    let title: String
    var disabled: Bool = false
    var accentColor: Color = Theme.accent
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appFont(15, weight: .bold))
                .foregroundStyle(disabled ? Theme.textMuted : Color.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: Theme.radiusMd)
                        .fill(disabled ? Color.white.opacity(0.08) : accentColor)
                )
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appFont(15, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: Theme.radiusMd)
                        .fill(Color.white.opacity(0.08))
                        .overlay(RoundedRectangle(cornerRadius: Theme.radiusMd).stroke(Theme.divider))
                )
        }
        .buttonStyle(.plain)
    }
}

struct IconBackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.right")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: Theme.radiusSm))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("رجوع")
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.appFont(14))
                .foregroundStyle(Theme.textSecondary)
            Spacer()
            Text(value)
                .font(.appFont(14, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
        }
    }
}

struct MenuRow: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.appFont(13))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Image(systemName: "chevron.left")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.textMuted)
            }
            .padding(14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
