//
//  BookingsView.swift
//  RestaurantBooking
//
//  Reservations tab. Cancel now actually persists (updates the shared
//  Firestore document via ReservationRepository), and there are TWO
//  ways to cancel - swipe, and an explicit button - since swipe alone
//  wasn't discoverable enough before.
//

import SwiftUI

struct BookingsView: View {
    @EnvironmentObject private var reservationRepo: ReservationRepository

    var body: some View {
        NavigationStack {
            List {
                if !reservationRepo.upcomingReservations.isEmpty {
                    Section("القادمة") {
                        ForEach(reservationRepo.upcomingReservations) { reservation in
                            ReservationRow(reservation: reservation)
                        }
                    }
                }

                if !reservationRepo.pastReservations.isEmpty {
                    Section("السابقة والملغاة") {
                        ForEach(reservationRepo.pastReservations) { reservation in
                            ReservationRow(reservation: reservation)
                        }
                    }
                }

                if reservationRepo.reservations.isEmpty {
                    emptyState
                }
            }
            .listStyle(.insetGrouped)
            .background(AppColor.background)
            .navigationTitle("الحجوزات")
        }
    }

    private var emptyState: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 44))
                .foregroundStyle(AppColor.textTertiary)
            Text("لا توجد حجوزات بعد")
                .font(.headline)
            Text("احجز طاولة من صفحة أي مطعم.")
                .font(.subheadline)
                .foregroundStyle(AppColor.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

private struct ReservationRow: View {
    @EnvironmentObject private var reservationRepo: ReservationRepository
    let reservation: Reservation
    @State private var isCancelling = false
    @State private var showCancelConfirm = false

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.sm) {
            VStack(alignment: .leading, spacing: 4) {
                Text(reservation.restaurantName)
                    .font(.subheadline.weight(.semibold))

                Text(reservation.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(AppColor.textSecondary)

                Text("\(reservation.partySize) \(reservation.partySize == 1 ? "ضيف" : "ضيوف") · \(reservation.contactPhone)")
                    .font(.caption)
                    .foregroundStyle(AppColor.textSecondary)

                if !reservation.specialRequest.isEmpty {
                    Text(reservation.specialRequest)
                        .font(.caption)
                        .foregroundStyle(AppColor.textTertiary)
                        .italic()
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                statusBadge
                if reservation.status == .upcoming {
                    Button(role: .destructive) {
                        showCancelConfirm = true
                    } label: {
                        if isCancelling {
                            ProgressView()
                        } else {
                            Text("إلغاء")
                                .font(.caption.weight(.semibold))
                        }
                    }
                    .disabled(isCancelling)
                }
            }
        }
        .padding(.vertical, 4)
        .swipeActions {
            if reservation.status == .upcoming {
                Button(role: .destructive) {
                    showCancelConfirm = true
                } label: {
                    Label("إلغاء", systemImage: "xmark")
                }
            }
        }
        .confirmationDialog(
            "إلغاء هذا الحجز؟",
            isPresented: $showCancelConfirm,
            titleVisibility: .visible
        ) {
            Button("إلغاء الحجز", role: .destructive) {
                Task { await cancel() }
            }
            Button("إبقاء الحجز", role: .cancel) {}
        }
    }

    private func cancel() async {
        isCancelling = true
        try? await reservationRepo.cancelReservation(reservation)
        isCancelling = false
    }

    private var statusBadge: some View {
        Text(label)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    private var label: String {
        switch reservation.status {
        case .upcoming: return "قادمة"
        case .completed: return "مكتملة"
        case .cancelled: return "ملغاة"
        }
    }

    private var color: Color {
        switch reservation.status {
        case .upcoming: return AppColor.success
        case .completed: return AppColor.textSecondary
        case .cancelled: return AppColor.danger
        }
    }
}

#Preview {
    BookingsView()
        .environmentObject(ReservationRepository())
}
