//
//  SignUpView.swift
//  RestaurantBooking
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var auth: AuthStore
    @Environment(\.dismiss) private var dismiss

    @State private var displayName = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""

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
                    AppTextField(placeholder: "الاسم الكامل", text: $displayName)
                    AppTextField(placeholder: "اسم المستخدم", text: $username, autocapitalize: false)
                    AppSecureField(placeholder: "كلمة المرور", text: $password)
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
                    if auth.signUp(displayName: displayName, username: username, password: password) {
                        dismiss()
                    }
                } label: {
                    Text("إنشاء الحساب")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColor.accent)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
                }
                .disabled(!canSubmit)
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
        !displayName.isEmpty && !username.isEmpty && !password.isEmpty && passwordsMatch
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
    .environmentObject(AuthStore())
}
