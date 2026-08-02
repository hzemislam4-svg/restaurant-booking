import SwiftUI
import Foundation

enum MockData {
    static let restaurants: [Restaurant] = [
        Restaurant(id: "r1", name: "مطعم الأصالة", cuisine: "شامي", area: "وسط المدينة",
                   rating: 4.7, price: "$$", distance: "0.8 كم",
                   hours: "12:00 ظهراً - 12:00 منتصف الليل", reviewCount: 342,
                   mapX: 28, mapY: 30, mapLat: 24.7136, mapLng: 46.6753,
                   description: "أجواء هادئة ومكان مناسب للعائلات والمجموعات. احجز مقعدك مسبقاً لضمان طاولتك في الوقت الذي يناسبك."),
        Restaurant(id: "r2", name: "بيت المشاوي", cuisine: "مشويات", area: "الحي الشرقي",
                   rating: 4.5, price: "$$", distance: "1.4 كم",
                   hours: "1:00 ظهراً - 1:00 فجراً", reviewCount: 198,
                   mapX: 68, mapY: 22, mapLat: 24.7411, mapLng: 46.6882,
                   description: "أشهر مشاوي المدينة مع تشكيلة واسعة من الأطباق المشوية على الفحم."),
        Restaurant(id: "r3", name: "لؤلؤة البحر", cuisine: "مأكولات بحرية", area: "الواجهة البحرية",
                   rating: 4.8, price: "$$$", distance: "2.1 كم",
                   hours: "1:00 ظهراً - 11:00 مساءً", reviewCount: 512,
                   mapX: 82, mapY: 62, mapLat: 24.6900, mapLng: 46.7000,
                   description: "مأكولات بحرية طازجة بإطلالة رائعة على الواجهة البحرية."),
        Restaurant(id: "r4", name: "نكهات آسيوية", cuisine: "آسيوي", area: "شارع الحديقة",
                   rating: 4.3, price: "$$", distance: "0.6 كم",
                   hours: "12:00 ظهراً - 11:00 مساءً", reviewCount: 127,
                   mapX: 40, mapY: 68, mapLat: 24.7333, mapLng: 46.6555,
                   description: "تشكيلة آسيوية متنوعة من السوشي والأطباق الحارة والأرز المقلي."),
        Restaurant(id: "r5", name: "ركن الإيطالي", cuisine: "إيطالي", area: "المنطقة التجارية",
                   rating: 4.6, price: "$$$", distance: "3.0 كم",
                   hours: "12:30 ظهراً - 12:00 منتصف الليل", reviewCount: 264,
                   mapX: 16, mapY: 78, mapLat: 24.7600, mapLng: 46.6700,
                   description: "بيتزا وباستا إيطالية أصيلة بوصفات تقليدية وخامات مستوردة."),
        Restaurant(id: "r6", name: "فطور وقهوة", cuisine: "إفطار وقهوة", area: "الحي الغربي",
                   rating: 4.4, price: "$", distance: "1.1 كم",
                   hours: "6:00 صباحاً - 5:00 مساءً", reviewCount: 89,
                   mapX: 58, mapY: 46, mapLat: 24.7200, mapLng: 46.6900,
                   description: "أفطار صباحي وقهوة مختصة في أجواء مريحة ومشمسة."),
    ]

    static let reviews: [Review] = [
        Review(name: "سارة العتيبي", stars: 5, comment: "خدمة ممتازة وأجواء رائعة، الحجز كان سهلاً جداً عبر التطبيق.", date: "قبل أسبوع"),
        Review(name: "خالد المطيري", stars: 4, comment: "طاولة مريحة وموقع مناسب، لكن الانتظار كان أطول من الوقت المحدد قليلاً.", date: "قبل أسبوعين"),
        Review(name: "منى الحربي", stars: 5, comment: "من أفضل الأماكن التي حجزت فيها، سأكرر التجربة بالتأكيد.", date: "قبل شهر"),
    ]

    static let tables: [TableSeat] = [
        TableSeat(id: "t1", x: 14, y: 12, seats: 2, status: .available),
        TableSeat(id: "t2", x: 46, y: 12, seats: 4, status: .reserved),
        TableSeat(id: "t3", x: 78, y: 12, seats: 2, status: .available),
        TableSeat(id: "t4", x: 14, y: 46, seats: 6, status: .available),
        TableSeat(id: "t5", x: 46, y: 46, seats: 4, status: .available),
        TableSeat(id: "t6", x: 78, y: 46, seats: 2, status: .reserved),
        TableSeat(id: "t7", x: 14, y: 80, seats: 4, status: .available),
        TableSeat(id: "t8", x: 46, y: 80, seats: 2, status: .available),
        TableSeat(id: "t9", x: 78, y: 80, seats: 6, status: .reserved),
    ]

    static let timeSlots = ["12:00", "13:30", "15:00", "19:00", "20:30", "22:00"]

    static let cuisines = ["الكل", "شامي", "مشويات", "مأكولات بحرية", "آسيوي", "إيطالي", "إفطار وقهوة"]

    static let plans: [Plan] = [
        Plan(id: "monthly", label: "شهري", price: "29", period: "ريال / شهرياً", badge: nil),
        Plan(id: "yearly", label: "سنوي", price: "249", period: "ريال / سنوياً", badge: "وفّر 28%"),
    ]
}
