import SwiftUI

struct MyBookingsView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        VStack(alignment: .trailing, spacing: 14) {
            Text("حجوزاتي")
                .font(.custom(Theme.fontName, size: 20, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 4)

            if store.bookings.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Text("لا توجد حجوزات بعد")
                        .font(.custom(Theme.fontName, size: 13))
                        .foregroundStyle(Theme.textSecondary)
                    PrimaryButton(title: "تصفح المطاعم", accentColor: store.accentColor) {
                        store.tab = .home
                    }
                    .frame(width: 200)
                }
                Spacer()
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(store.bookingsUpcomingFirst) { booking in
                            BookingRow(booking: booking)
                        }
                    }
                    .padding(.bottom, 110)
                }
                .scrollIndicators(.hidden)
            }
        }
        .padding(.horizontal, 20)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct BookingRow: View {
    @EnvironmentObject var store: AppStore
    let booking: Booking

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack {
                Text(booking.restaurantName)
                    .font(.custom(Theme.fontName, size: 15, weight: .medium))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                TagView(text: booking.statusLabel, accent: booking.status == .upcoming)
            }
            Text("\(booking.date) · \(booking.time) · \(booking.guests) أشخاص")
                .font(.custom(Theme.fontName, size: 12))
                .foregroundStyle(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .trailing)

            if booking.status == .upcoming {
                HStack {
                    Spacer()
                    Button {
                        store.cancelBooking(booking.id)
                    } label: {
                        Text("إلغاء الحجز")
                            .font(.custom(Theme.fontName, size: 12, weight: .medium))
                            .foregroundStyle(Theme.danger)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Theme.danger.opacity(0.12))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: Theme.radiusMd)
                .fill(Theme.card)
        )
    }
}
