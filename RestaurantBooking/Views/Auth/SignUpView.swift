//
//  SignUpView.swift
//  RestaurantBooking
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var auth: FirebaseAuthService
    @Environment(\.dismiss) private var dismiss

    @State private var displayName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var role: UserRole = .diner

    private var passwordsMatch: Bool { password == confirmPassword }

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                VStack(spacing: 6) {
                    Text("أنشئ حسابك")
                        .font(.displayTitle)
                    Text("يستغرق أقل من دقيقة")
                        .font(.subheadline)
                        .foregroundStyle(AppColor.textSecondary)
                }
                .padding(.top, AppSpacing.lg)

                VStack(spacing: AppSpacing.sm) {
                    Picker("أنا...", selection: $role) {
                        Text("زبون").tag(UserRole.diner)
                        Text("صاحب مطعم").tag(UserRole.owner)
                    }
                    .pickerStyle(.segmented)

                    AppTextField(placeholder: "الاسم الكامل", text: $displayName)
                    AppTextField(placeholder: "البريد الإلكتروني", text: $email, autocapitalize: false)
                        .keyboardType(.emailAddress)
                    AppSecureField(placeholder: "كلمة المرور (6 أحرف على الأقل)", text: $password)
                    AppSecureField(placeholder: "تأكيد كلمة المرور", text: $confirmPassword)
                }

                if !confirmPassword.isEmpty && !passwordsMatch {
                    Text("كلمتا المرور غير متطابقتين.")
                        .font(.footnote)
                        .foregroundStyle(AppColor.danger)
                }

                if let error = auth.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(AppColor.danger)
                        .multilineTextAlignment(.center)
                }

                Button {
                    Task {
                        await auth.signUp(displayName: displayName, email: email, password: password, role: role)
                        if auth.isLoggedIn { dismiss() }
                    }
                } label: {
                    if auth.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("إنشاء الحساب")
                    }
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColor.accent)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
                .disabled(!canSubmit || auth.isLoading)
                .opacity(canSubmit ? 1 : 0.5)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xl)
        }
        .background(AppColor.background)
        .navigationTitle("إنشاء حساب")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var canSubmit: Bool {
        !displayName.isEmpty && !email.isEmpty && !password.isEmpty && passwordsMatch
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
    .environmentObject(FirebaseAuthService())
}
