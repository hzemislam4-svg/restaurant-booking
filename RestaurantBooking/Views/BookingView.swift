//
//  BookingView.swift
//  RestaurantBooking
//

import SwiftUI

struct BookingView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss

    let restaurant: Restaurant

    @State private var selectedDate = Date().addingTimeInterval(60 * 60 * 2)
    @State private var partySize = 2
    @State private var specialRequest = ""
    @State private var showConfirmation = false

    private let partySizes = Array(1...10)

    var body: some View {
        NavigationStack {
            if showConfirmation {
                confirmationView
            } else {
                formView
            }
        }
    }

    private var formView: some View {
        Form {
            Section {
                HStack {
                    RestaurantImagePlaceholder(cuisine: restaurant.cuisine)
                        .frame(width: 56, height: 56)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(restaurant.name).font(.headline)
                        Text(restaurant.neighborhood)
                            .font(.caption)
                            .foregroundStyle(AppColor.textSecondary)
                    }
                }
                .padding(.vertical, 4)
            }

            Section("التاريخ والوقت") {
                DatePicker("التاريخ", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                DatePicker("الوقت", selection: $selectedDate, displayedComponents: .hourAndMinute)
            }

            Section("عدد الأشخاص") {
                Picker("الضيوف", selection: $partySize) {
                    ForEach(partySizes, id: \.self) { size in
                        Text(size == 1 ? "ضيف واحد" : "\(size) ضيوف").tag(size)
                    }
                }
                .pickerStyle(.menu)
            }

            Section("طلب خاص (اختياري)") {
                TextField("منظر النافذة، عيد ميلاد، حساسية...", text: $specialRequest, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }

            Section {
                Button {
                    confirmBooking()
                } label: {
                    Text("تأكيد الحجز")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .listRowBackground(AppColor.accent)
                .foregroundStyle(.white)
            }
        }
        .navigationTitle("احجز طاولة")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("إلغاء") { dismiss() }
            }
        }
    }

    private var confirmationView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(AppColor.success)

            VStack(spacing: 8) {
                Text("تم حجز الطاولة")
                    .font(.title2.bold())
                Text("تم حجزك في \(restaurant.name)")
                    .font(.subheadline)
                    .foregroundStyle(AppColor.textSecondary)
            }

            VStack(spacing: 12) {
                summaryRow(icon: "calendar", text: selectedDate.formatted(date: .abbreviated, time: .omitted))
                summaryRow(icon: "clock", text: selectedDate.formatted(date: .omitted, time: .shortened))
                summaryRow(icon: "person.2", text: partySize == 1 ? "ضيف واحد" : "\(partySize) ضيوف")
            }
            .padding(AppSpacing.md)
            .background(AppColor.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
            .padding(.horizontal, AppSpacing.lg)

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("تم")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColor.accent)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.md)
        }
    }

    private func summaryRow(icon: String, text: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(AppColor.accent)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }

    private func confirmBooking() {
        let reservation = Reservation(
            restaurantId: restaurant.id,
            restaurantName: restaurant.name,
            date: selectedDate,
            partySize: partySize,
            specialRequest: specialRequest
        )
        store.addReservation(reservation)
        withAnimation {
            showConfirmation = true
        }
    }
}

#Preview {
    BookingView(restaurant: SampleData.restaurants[0])
        .environmentObject(AppStore())
}
