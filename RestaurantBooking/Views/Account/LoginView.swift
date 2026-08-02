import SwiftUI
import UIKit

struct LoginView: View {
    @EnvironmentObject var store: AppStore
    @State private var identifier: String = ""
    @State private var password: String = ""
    @State private var isGoogleLoading = false

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack {
                Spacer()
                Button {
                    store.flow = nil
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusSm))
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 20)

            Text("تسجيل الدخول")
                .font(.custom(Theme.fontName, size: 24, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 4)

            Text("سجّل دخولك لإدارة حجوزاتك ومفضلتك")
                .font(.custom(Theme.fontName, size: 13))
                .foregroundStyle(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 20)

            VStack(spacing: 14) {
                VStack(alignment: .trailing, spacing: 6) {
                    Text("رقم الجوال أو البريد الإلكتروني")
                        .font(.custom(Theme.fontName, size: 13, weight: .medium))
                        .foregroundStyle(Theme.textPrimary)
                    TextField("05xxxxxxxx", text: $identifier)
                        .font(.custom(Theme.fontName, size: 14))
                        .foregroundStyle(Theme.textPrimary)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.radiusSm)
                                .fill(Color.white.opacity(0.06))
                                .overlay(RoundedRectangle(cornerRadius: Theme.radiusSm).stroke(Theme.divider))
                        )
                }

                VStack(alignment: .trailing, spacing: 6) {
                    Text("كلمة المرور")
                        .font(.custom(Theme.fontName, size: 13, weight: .medium))
                        .foregroundStyle(Theme.textPrimary)
                    SecureField("••••••••", text: $password)
                        .font(.custom(Theme.fontName, size: 14))
                        .foregroundStyle(Theme.textPrimary)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.radiusSm)
                                .fill(Color.white.opacity(0.06))
                                .overlay(RoundedRectangle(cornerRadius: Theme.radiusSm).stroke(Theme.divider))
                        )
                }

                PrimaryButton(title: "تسجيل الدخول", accentColor: store.accentColor) {
                    store.loginDemo()
                }

                SecondaryButton(title: "إنشاء حساب جديد") {
                    store.loginDemo()
                }

                if store.user.initial.isEmpty {
                    Button {
                        isGoogleLoading = true
                        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let root = scene.windows.first?.rootViewController else {
                            isGoogleLoading = false
                            return
                        }
                        GoogleAuthManager.shared.signIn(presenting: root) { result in
                            DispatchQueue.main.async {
                                isGoogleLoading = false
                                switch result {
                                case .success(let profile):
                                    store.loginWithGoogle(profile: profile)
                                case .failure:
                                    break
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 10) {
                            if isGoogleLoading {
                                ProgressView()
                                    .tint(Theme.textPrimary)
                            } else {
                                GoogleIconView()
                            }
                            Text(isGoogleLoading ? "جارٍ الاتصال بجوجل..." : "المتابعة عبر جوجل")
                                .font(.custom(Theme.fontName, size: 15, weight: .bold))
                        }
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

                Button {
                    store.flow = nil
                } label: {
                    Text("المتابعة كزائر")
                        .font(.custom(Theme.fontName, size: 12))
                        .foregroundStyle(store.accentColor)
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
            Spacer()
        }
        .padding(20)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct GoogleIconView: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("G")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color(hex: "4285F4"))
            Text("oogle")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Color.white)
        }
    }
}
