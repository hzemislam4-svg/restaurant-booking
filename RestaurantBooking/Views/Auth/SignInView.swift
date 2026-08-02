//
//  SignInView.swift
//  RestaurantBooking
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var auth: SessionStore
    @State private var name = ""
    @State private var role: UserRole = .diner

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer(minLength: AppSpacing.xl)

            VStack(spacing: 6) {
                Image(systemName: "fork.knife.circle.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(AppColor.accent)
                Text("أهلاً بك")
                    .font(.displayTitle)
                Text("اكتب اسمك وادخل مباشرة")
                    .font(.subheadline)
                    .foregroundStyle(AppColor.textSecondary)
            }

            VStack(spacing: AppSpacing.sm) {
                TextField("اسمك", text: $name)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, 14)
                    .background(AppColor.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))

                Picker("الدور", selection: $role) {
                    Text("زبون").tag(UserRole.diner)
                    Text("صاحب مطعم").tag(UserRole.owner)
                }
                .pickerStyle(.segmented)
            }

            Button {
                auth.logIn(name: name, role: role)
            } label: {
                Text("دخول")
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppColor.accent)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(name.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)

            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
        .background(AppColor.background)
    }
}

#Preview {
    SignInView()
        .environmentObject(SessionStore())
}
