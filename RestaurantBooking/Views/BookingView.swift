//
//  BookingView.swift
//  RestaurantBooking
//
//  Booking sheet - date/time/party size + contact details, and a
//  required confirmation step so a reservation isn't just one tap of
//  "maybe". This is the free alternative to SMS verification: a real
//  name, a real phone number, and an explicit checkbox commitment,
//  all stored with the reservation so the restaurant can follow up.
//

import SwiftUI

struct BookingView: View {
    @EnvironmentObject private var auth: SessionStore
    @EnvironmentObject private var reservationRepo: ReservationRepository
    @Environment(\.dismiss) private var dismiss

    let restaurant: Restaurant

    @State private var selectedDate = Date().addingTimeInterval(60 * 60 * 2)
    @State private var partySize = 2
    @State private var contactName = ""
    @State private var contactPhone = ""
    @State private var specialRequest = ""
    @State private var confirmedIntent = false

    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var showConfirmation = false

    private let partySizes = Array(1...10)

    private var canSubmit: Bool {
        !contactName.isEmpty && !contactPhone.isEmpty && confirmedIntent
    }

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

            Section("حجم المجموعة") {
                Picker("الضيوف", selection: $partySize) {
                    ForEach(partySizes, id: \.self) { size in
                        Text("\(size) \(size == 1 ? "ضيف" : "ضيوف")").tag(size)
                    }
                }
                .pickerStyle(.menu)
            }

            Section("بيانات التواصل") {
                TextField("الاسم الكامل", text: $contactName)
                TextField("رقم الهاتف", text: $contactPhone)
                    .keyboardType(.phonePad)
                Text("قد يتصل المطعم لتأكيد طاولتك.")
                    .font(.caption2)
                    .foregroundStyle(AppColor.textTertiary)
            }

            Section("طلب خاص (اختياري)") {
                TextField("نافذة، عيد ميلاد، حساسية...", text: $specialRequest, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }

            Section {
                Toggle(isOn: $confirmedIntent) {
                    Text("أؤكد أنني أنوي الحضور لهذا الحجز وأتفهم أن المطعم قد يتواصل معي للتأكيد.")
                        .font(.footnote)
                }
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(AppColor.danger)
                }
            }

            Section {
                Button {
                    Task { await confirmBooking() }
                } label: {
                    if isSaving {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("تأكيد الحجز")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                }
                .disabled(!canSubmit || isSaving)
                .listRowBackground(canSubmit ? AppColor.accent : AppColor.secondaryBackground)
                .foregroundStyle(canSubmit ? .white : AppColor.textTertiary)
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
                summaryRow(icon: "person.2", text: "\(partySize) \(partySize == 1 ? "ضيف" : "ضيوف")")
                summaryRow(icon: "phone", text: contactPhone)
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

    private func confirmBooking() async {
        guard let customerId = auth.currentUser?.uid else { return }
        isSaving = true
        errorMessage = nil

        let reservation = Reservation(
            restaurantId: restaurant.id,
            restaurantName: restaurant.name,
            customerId: customerId,
            date: selectedDate,
            partySize: partySize,
            specialRequest: specialRequest,
            contactName: contactName,
            contactPhone: contactPhone,
            confirmedIntent: confirmedIntent
        )

        do {
            try await reservationRepo.addReservation(reservation)
            isSaving = false
            withAnimation { showConfirmation = true }
        } catch {
            isSaving = false
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    BookingView(restaurant: PreviewFixtures.restaurant)
        .environmentObject(SessionStore())
        .environmentObject(ReservationRepository())
}
