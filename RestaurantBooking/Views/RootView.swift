import SwiftUI

struct RootView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            if let flow = store.flow {
                FlowView(flow: flow)
                    .transition(.opacity)
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: store.flow == nil)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct FlowView: View {
    @EnvironmentObject var store: AppStore
    let flow: Flow

    var body: some View {
        switch flow {
        case .detail(let restaurant):
            RestaurantDetailView(restaurant: restaurant)
        case .booking(let restaurant):
            BookingView(restaurant: restaurant)
        case .tableSelection(let restaurant):
            TableSelectionView(restaurant: restaurant)
        case .confirmation(let restaurant):
            BookingConfirmationView(restaurant: restaurant)
        case .payment(let plan):
            PaymentView(plan: plan)
        case .account:
            AccountView()
        case .membership:
            MembershipView()
        }
    }
}
