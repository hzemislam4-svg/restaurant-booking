//
//  SignInView.swift
//  RestaurantBooking
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var auth: AuthStore
    @State private var username = ""
    @State private var password = ""
    @State private var goToSignUp = false

    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.lg) {
                Spacer(minLength: AppSpacing.xl)

                VStack(spacing: 6) {
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 52))
                        .foregroundStyle(AppColor.accent)
                    Text("مرحباً بعودتك")
                        .font(.displayTitle)
                    Text("سجّل الدخول لحجز طاولتك")
                        .font(.subheadline)
                        .foregroundStyle(AppColor.textSecondary)
                }

                VStack(spacing: AppSpacing.sm) {
                    AppTextField(placeholder: "اسم المستخدم", text: $username, autocapitalize: false)
                    AppSecureField(placeholder: "كلمة المرور", text: $password)
                }

                if let error = auth.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(AppColor.danger)
                        .multilineTextAlignment(.center)
                }

                Button {
                    _ = auth.logIn(username: username, password: password)
                } label: {
                    Text("تسجيل الدخول")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColor.accent)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
                }
                .disabled(username.isEmpty || password.isEmpty)
                .opacity(username.isEmpty || password.isEmpty ? 0.5 : 1)

                Spacer()

                Button {
                    auth.errorMessage = nil
                    goToSignUp = true
                } label: {
                    HStack(spacing: 4) {
                        Text("ليس لديك حساب؟")
                            .foregroundStyle(AppColor.textSecondary)
                        Text("أنشئ حساباً")
                            .foregroundStyle(AppColor.accent)
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                }
                .padding(.bottom, AppSpacing.md)
            }
            .padding(.horizontal, AppSpacing.lg)
            .background(AppColor.background)
            .navigationDestination(isPresented: $goToSignUp) {
                SignUpView()
            }
        }
    }
}

/// Shared plain text field styling used by both auth screens.
struct AppTextField: View {
    let placeholder: String
    @Binding var text: String
    var autocapitalize: Bool = true

    var body: some View {
        TextField(placeholder, text: $text)
            .textInputAutocapitalization(autocapitalize ? .words : .never)
            .autocorrectionDisabled()
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, 14)
            .background(AppColor.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
    }
}

/// Shared secure field styling used by both auth screens.
struct AppSecureField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        SecureField(placeholder, text: $text)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, 14)
            .background(AppColor.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthStore())
}
