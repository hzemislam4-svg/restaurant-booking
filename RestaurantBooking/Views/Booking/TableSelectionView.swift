import SwiftUI

struct TableSelectionView: View {
    @EnvironmentObject var store: AppStore
    let restaurant: Restaurant

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    IconBackButton { store.flow = .booking(restaurant) }
                    Text("اختر طاولتك")
                        .font(.appFont(17, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

                Text("\(dateLabel) · \(store.selectedTime ?? "") · \(store.guests) أشخاص")
                    .font(.appFont(12))
                    .foregroundStyle(Theme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)

                floorplan

                legend
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)

                PrimaryButton(title: "متابعة إلى التأكيد",
                              disabled: store.selectedTable == nil,
                              accentColor: store.accentColor) {
                    store.flow = .confirmation(restaurant)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
        .scrollIndicators(.hidden)
        .environment(\.layoutDirection, .rightToLeft)
    }

    private var dateLabel: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ar")
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: store.selectedDate)
    }

    private var floorplan: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Theme.radiusLg)
                .fill(Theme.surface)
                .overlay(RoundedRectangle(cornerRadius: Theme.radiusLg).stroke(Theme.divider))

            // خطوط شبكة خفيفة لمحاكاة مخطط الطاولات
            Canvas { ctx, size in
                var path = Path()
                let spacing: CGFloat = size.height / 4
                for i in 1..<4 {
                    path.move(to: CGPoint(x: 0, y: spacing * CGFloat(i)))
                    path.addLine(to: CGPoint(x: size.width, y: spacing * CGFloat(i)))
                }
                for i in 1..<3 {
                    path.move(to: CGPoint(x: size.width * CGFloat(i) / 3, y: 0))
                    path.addLine(to: CGPoint(x: size.width * CGFloat(i) / 3, y: size.height))
                }
                ctx.stroke(path, with: .color(Theme.textPrimary.opacity(0.06)), lineWidth: 1)
            }

            ForEach(MockData.tables) { table in
                TableCircleView(table: table,
                                isSelected: store.selectedTable?.id == table.id,
                                accentColor: store.accentColor) {
                    if table.status == .available {
                        store.selectedTable = table
                    }
                }
                .position(x: CGFloat(table.x) / 100 * 300, y: CGFloat(table.y) / 100 * 300)
            }
        }
        .frame(width: 300, height: 300)
        .padding(.horizontal, 20)
    }

    private var legend: some View {
        HStack(spacing: 16) {
            LegendDot(color: Theme.surfaceAlt, border: Theme.divider, label: "متاح")
            LegendDot(color: Theme.reserved.opacity(0.4), border: .clear, label: "محجوز")
            LegendDot(color: store.accentColor, border: .clear, label: "مختار")
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct TableCircleView: View {
    let table: TableSeat
    let isSelected: Bool
    var accentColor: Color = Theme.accent
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(table.seats)")
                .font(.appFont(12, weight: .medium))
                .foregroundStyle(foreground)
                .frame(width: table.circleSize, height: table.circleSize)
                .background(Circle().fill(background))
                .overlay(
                    Circle().stroke(isSelected ? accentColor : Theme.divider,
                                    lineWidth: isSelected ? 1.5 : 1)
                )
                .shadow(color: isSelected ? accentColor.opacity(0.4) : .clear, radius: isSelected ? 5 : 0)
        }
        .buttonStyle(.plain)
        .disabled(table.status == .reserved)
        .opacity(table.status == .reserved ? 0.4 : 1)
    }

    private var foreground: Color {
        isSelected ? Theme.background : Theme.textPrimary
    }

    private var background: Color {
        if isSelected { return accentColor }
        if table.status == .reserved { return Theme.reserved.opacity(0.5) }
        return Theme.surfaceAlt
    }
}

struct LegendDot: View {
    let color: Color
    let border: Color
    let label: String

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 9, height: 9)
                .overlay(Circle().stroke(border))
            Text(label)
                .font(.appFont(11))
                .foregroundStyle(Theme.textSecondary)
        }
    }
}
