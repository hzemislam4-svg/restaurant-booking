//
//  ContactUsView.swift
//  RestaurantBooking
//

import SwiftUI

struct ContactUsView: View {
    @State private var subject = ""
    @State private var message = ""
    @State private var sent = false

    var body: some View {
        Form {
            Section("تواصل معنا مباشرة") {
                Label("support@restaurantbooking.app", systemImage: "envelope")
                Label("+213 000 000 000", systemImage: "phone")
            }

            Section("أرسل رسالة") {
                TextField("الموضوع", text: $subject)
                TextField("الرسالة", text: $message, axis: .vertical)
                    .lineLimit(5, reservesSpace: true)
            }

            Section {
                Button {
                    sent = true
                    subject = ""
                    message = ""
                } label: {
                    Text("إرسال")
                        .frame(maxWidth: .infinity)
                }
                .disabled(subject.isEmpty || message.isEmpty)
            }

            if sent {
                Section {
                    Label("تم إرسال الرسالة — سنعاود التواصل معك قريباً.", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(AppColor.success)
                }
            }
        }
        .navigationTitle("تواصل معنا")
    }
}

#Preview {
    NavigationStack { ContactUsView() }
}
