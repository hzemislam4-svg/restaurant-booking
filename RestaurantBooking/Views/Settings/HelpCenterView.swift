//
//  HelpCenterView.swift
//  RestaurantBooking
//

import SwiftUI

struct HelpCenterView: View {
    private let faqs: [(String, String)] = [
        ("كيف ألغي حجزاً؟", "اذهب إلى تبويب الحجوزات، ابحث عن الحجز تحت القادمة، واضغط إلغاء (أو اسحب لليسار عليه)."),
        ("كيف أصبح شريكاً للمطاعم؟", "افتح الملف الشخصي → كن شريكاً للمطاعم، اشترك في خطة، ثم أضف تفاصيل مطعمك وصوره."),
        ("هل بيانات الدفع حقيقية؟", "لا في هذه النسخة — الاشتراكات والبطاقات المحفوظة تجربة شكلية ولا يحدث أي خصم حقيقي."),
        ("لماذا لا أرى أي مطاعم؟", "التطبيق يعرض فقط المطاعم التي نشرها أصحاب حقيقيون. إذا كانت القائمة فارغة، كن أول من يضيف مطعماً كشريك للمطاعم."),
        ("كيف أغير إعدادات الإشعارات؟", "اذهب إلى الملف الشخصي → الإشعارات وبدّل ما تريد استلامه."),
    ]

    var body: some View {
        List {
            Section("الأسئلة الشائعة") {
                ForEach(faqs, id: \.0) { question, answer in
                    DisclosureGroup(question) {
                        Text(answer)
                            .font(.subheadline)
                            .foregroundStyle(AppColor.textSecondary)
                            .padding(.top, 4)
                    }
                    .font(.subheadline.weight(.semibold))
                }
            }
        }
        .navigationTitle("مركز المساعدة")
    }
}

#Preview {
    NavigationStack { HelpCenterView() }
}
