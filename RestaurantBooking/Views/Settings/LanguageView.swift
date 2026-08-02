//
//  LanguageView.swift
//  RestaurantBooking
//

import SwiftUI

struct LanguageView: View {
    @AppStorage("preferredLanguage") private var preferredLanguage = "ar"

    private let languages = [
        ("ar", "العربية"),
        ("en", "English"),
        ("fr", "Français"),
    ]

    var body: some View {
        List {
            Section {
                ForEach(languages, id: \.0) { code, name in
                    Button {
                        preferredLanguage = code
                    } label: {
                        HStack {
                            Text(name)
                                .foregroundStyle(AppColor.textPrimary)
                            Spacer()
                            if preferredLanguage == code {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(AppColor.accent)
                            }
                        }
                    }
                }
            } footer: {
                Text("الترجمة الكاملة للتطبيق غير موصولة بعد في هذه النسخة — هذا يحفظ تفضيلك للوقت الذي ستتوفر فيه.")
            }
        }
        .navigationTitle("اللغة")
    }
}

#Preview {
    NavigationStack { LanguageView() }
}
