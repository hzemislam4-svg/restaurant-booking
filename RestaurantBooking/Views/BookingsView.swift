//
//  BookingsView.swift
//  RestaurantBooking
//

import SwiftUI

struct BookingsView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        NavigationStack {
            List {
                if !store.upcomingReservations.isEmpty {
                    Section("القادمة") {
                        ForEach(store.upcomingReservations) { reservation in
                            ReservationRow(reservation: reservation)
                        }
                    }
                }

                if !store.pastReservations.isEmpty {
                    Section("السابقة والملغاة") {
                        ForEach(store.pastReservations) { reservation in
                            ReservationRow(reservation: reservation)
                        }
                    }
                }

                if store.reservations.isEmpty {
                    emptyState
                }
            }
            .listStyle(.insetGrouped)
            .background(AppColor.background)
            .navigationTitle("حجوزاتي")
        }
    }

    private var emptyState: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 44))
                .foregroundStyle(AppColor.textTertiary)
            Text("لا توجد حجوزات بعد")
                .font(.headline)
            Text("احجز طاولة من أي صفحة مطعم.")
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
    @EnvironmentObject private var store: AppStore
    let reservation: Reservation

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.sm) {
            VStack(alignment: .leading, spacing: 4) {
                Text(reservation.restaurantName)
                    .font(.subheadline.weight(.semibold))

                Text(reservation.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(AppColor.textSecondary)

                Text(reservation.partySize == 1 ? "ضيف واحد" : "\(reservation.partySize) ضيوف")
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

            statusBadge
        }
        .padding(.vertical, 4)
        .swipeActions {
            if reservation.status == .upcoming {
                Button(role: .destructive) {
                    store.cancelReservation(reservation)
                } label: {
                    Label("إلغاء", systemImage: "xmark")
                }
            }
        }
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
        .environmentObject(AppStore())
}
