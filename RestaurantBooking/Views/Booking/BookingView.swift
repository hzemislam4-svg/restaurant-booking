import SwiftUI

struct BookingView: View {
    @EnvironmentObject var store: AppStore
    let restaurant: Restaurant

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    IconBackButton { store.flow = .detail(restaurant) }
                    Text("تفاصيل الحجز")
                        .font(.custom(Theme.fontName, size: 17, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

                VStack(spacing: 18) {
                    dateField
                    guestsField
                    timeField
                    PrimaryButton(title: "متابعة إلى اختيار الطاولة",
                                  disabled: store.selectedTime == nil,
                                  accentColor: store.accentColor) {
                        store.flow = .tableSelection(restaurant)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            }
            .padding(.bottom, 40)
        }
        .scrollIndicators(.hidden)
        .environment(\.layoutDirection, .rightToLeft)
    }

    private var dateField: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text("التاريخ")
                .font(.custom(Theme.fontName, size: 13, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
            DatePicker("", selection: $store.selectedDate,
                       in: Date()...,
                       displayedComponents: .date)
                .datePickerStyle(.compact)
                .environment(\.layoutDirection, .rightToLeft)
                .labelsHidden()
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: Theme.radiusSm)
                        .fill(Color.white.opacity(0.06))
                        .overlay(RoundedRectangle(cornerRadius: Theme.radiusSm).stroke(Theme.divider))
                )
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private var guestsField: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text("عدد الأشخاص")
                .font(.custom(Theme.fontName, size: 13, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
            HStack(spacing: 14) {
                Button {
                    store.guests = max(1, store.guests - 1)
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusSm))
                }
                .buttonStyle(.plain)

                Text("\(store.guests)")
                    .font(.custom(Theme.fontName, size: 18, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)
                    .frame(minWidth: 24)

                Button {
                    store.guests = min(12, store.guests + 1)
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusSm))
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private var timeField: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text("اختر الوقت")
                .font(.custom(Theme.fontName, size: 13, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8) {
                ForEach(MockData.timeSlots, id: \.self) { slot in
                    ChipView(label: slot,
                             selected: store.selectedTime == slot,
                             accentColor: store.accentColor) {
                        store.selectedTime = slot
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
