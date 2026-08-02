import SwiftUI

struct AccountView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            if !store.isLoggedIn {
                LoginView()
            } else {
                accountContent
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }

    private var accountContent: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text("حسابي")
                .font(.custom(Theme.fontName, size: 24, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 18)

            HStack(spacing: 12) {
                Text(store.user.initial.isEmpty ? "؟" : store.user.initial)
                    .font(.custom(Theme.fontName, size: 20, weight: .bold))
                    .foregroundStyle(Theme.accent)
                    .frame(width: 56, height: 56)
                    .background(Theme.accent.opacity(0.15))
                    .clipShape(Circle())

                VStack(alignment: .trailing, spacing: 3) {
                    Text(store.user.name.isEmpty ? "زائر" : store.user.name)
                        .font(.custom(Theme.fontName, size: 16, weight: .medium))
                        .foregroundStyle(Theme.textPrimary)
                    Text(store.user.phone.isEmpty ? (store.user.email.isEmpty ? "غير مسجل" : store.user.email) : store.user.phone)
                        .font(.custom(Theme.fontName, size: 12))
                        .foregroundStyle(Theme.textSecondary)
                }
                Spacer()
                TagView(text: store.user.membershipLabel, accent: store.user.isPremium)
            }
            .padding(.bottom, 18)

            VStack(spacing: 1) {
                MenuRow(title: "العضوية المميزة") {
                    store.flow = .membership
                }
                Divider().overlay(Theme.divider).padding(.leading, 14)
                MenuRow(title: "حجوزاتي") {
                    store.flow = nil
                    store.tab = .bookings
                }
                Divider().overlay(Theme.divider).padding(.leading, 14)
                MenuRow(title: "المفضلة") {
                    store.flow = nil
                    store.tab = .favorites
                }
            }
            .background(
                RoundedRectangle(cornerRadius: Theme.radiusMd)
                    .fill(Theme.surface)
            )
            .padding(.bottom, 16)

            VStack(alignment: .trailing, spacing: 8) {
                Text("اختر لون التطبيق")
                    .font(.custom(Theme.fontName, size: 12))
                    .foregroundStyle(Theme.textSecondary)
                HStack(spacing: 12) {
                    ForEach(AccentTheme.allCases) { theme in
                        let selected = store.user.accentTheme == theme.rawValue
                        Button {
                            store.user.accentTheme = theme.rawValue
                        } label: {
                            Circle()
                                .fill(theme.color)
                                .frame(width: 28, height: 28)
                                .overlay(
                                    Circle().stroke(selected ? Color.white : .clear, lineWidth: 2)
                                )
                                .shadow(color: theme.color.opacity(selected ? 0.7 : 0), radius: selected ? 5 : 0)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.bottom, 20)

            SecondaryButton(title: "تسجيل الخروج") {
                store.logout()
            }

            Spacer()
        }
        .padding(20)
    }
}
