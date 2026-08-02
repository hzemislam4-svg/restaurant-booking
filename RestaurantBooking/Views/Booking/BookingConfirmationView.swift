import SwiftUI

struct BookingConfirmationView: View {
    @EnvironmentObject var store: AppStore
    let restaurant: Restaurant

    private var dateLabel: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ar")
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: store.selectedDate)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    IconBackButton { store.flow = .tableSelection(restaurant) }
                    Text("تأكيد الحجز")
                        .font(.custom(Theme.fontName, size: 17, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

                VStack(spacing: 0) {
                    VStack(spacing: 12) {
                        Text("ملخص الحجز")
                            .font(.custom(Theme.fontName, size: 12, weight: .medium))
                            .foregroundStyle(Theme.accent)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        InfoRow(label: "المطعم", value: restaurant.name)
                        InfoRow(label: "التاريخ", value: dateLabel)
                        InfoRow(label: "الوقت", value: store.selectedTime ?? "-")
                        InfoRow(label: "عدد الأشخاص", value: "\(store.guests)")
                        InfoRow(label: "الطاولة", value: "تتسع لـ \(store.selectedTable?.seats ?? 0) أشخاص")
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.radiusMd)
                            .fill(Theme.card)
                    )

                    Text("طلب الطعام مسبقاً سيتوفر لاحقاً — هذا الحجز يضمن مقعدك فقط.")
                        .font(.custom(Theme.fontName, size: 12))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.vertical, 14)

                    PrimaryButton(title: "تأكيد الحجز", accentColor: store.accentColor) {
                        confirm()
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            }
        }
        .scrollIndicators(.hidden)
        .environment(\.layoutDirection, .rightToLeft)
    }

    private func confirm() {
        let booking = Booking(
            id: "b\(Int(Date().timeIntervalSince1970))",
            restaurantName: restaurant.name,
            date: dateLabel,
            time: store.selectedTime ?? "",
            guests: store.guests,
            tableSeats: store.selectedTable?.seats ?? 0,
            status: .upcoming
        )
        store.addBooking(booking)
        store.selectedTime = nil
        store.selectedTable = nil
        store.flow = nil
        store.tab = .bookings
    }
}
