//
//  AboutView.swift
//  RestaurantBooking
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: AppSpacing.sm) {
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(AppColor.accent)
                    Text("حجز المطاعم")
                        .font(.headline)
                    Text("الإصدار 1.0.0")
                        .font(.caption)
                        .foregroundStyle(AppColor.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.md)
            }
            .listRowBackground(Color.clear)

            Section("حول التطبيق") {
                Text("اكتشف المطاعم، احفظ مفضلاتك، واحجز طاولة في ثوانٍ. يمكن لأصحاب المطاعم عرض مكانهم والبدء باستقبال الحجوزات مباشرة من زبائن التطبيق.")
                    .font(.subheadline)
                    .foregroundStyle(AppColor.textSecondary)
            }

            Section("قانوني") {
                Label("شروط الخدمة", systemImage: "doc.text")
                Label("سياسة الخصوصية", systemImage: "hand.raised")
            }
        }
        .navigationTitle("حول التطبيق")
    }
}

#Preview {
    NavigationStack { AboutView() }
}
