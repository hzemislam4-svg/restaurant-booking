//
//  NotificationsSettingsView.swift
//  RestaurantBooking
//

import SwiftUI

struct NotificationsSettingsView: View {
    @AppStorage("notif_reservationReminders") private var reservationReminders = true
    @AppStorage("notif_promotions") private var promotions = false
    @AppStorage("notif_newRestaurants") private var newRestaurants = true

    var body: some View {
        List {
            Section("الحجوزات") {
                Toggle("تذكيرات الحجوزات القادمة", isOn: $reservationReminders)
            }
            Section("الاكتشاف") {
                Toggle("المطاعم الجديدة القريبة منك", isOn: $newRestaurants)
                Toggle("العروض والترويجات", isOn: $promotions)
            }
        }
        .navigationTitle("الإشعارات")
    }
}

#Preview {
    NavigationStack { NotificationsSettingsView() }
}
