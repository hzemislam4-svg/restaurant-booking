//
//  SetupRequiredView.swift
//  RestaurantBooking
//
//  Shown when GoogleService-Info.plist is missing from the bundle,
//  so the app fails gracefully instead of crashing at launch.
//

import SwiftUI

struct SetupRequiredView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 56))
                .foregroundColor(.orange)
            Text("إعداد مطلوب")
                .font(.title.bold())
            Text("يحتاج التطبيق إلى ملف GoogleService-Info.plist\nلتشغيل خدمة السحابة. أضف الملف إلى المشروع\nثم أعد البناء.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    SetupRequiredView()
        .preferredColorScheme(.dark)
}
