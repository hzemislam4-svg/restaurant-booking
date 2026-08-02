//
//  SampleData.swift
//  RestaurantBooking
//

import Foundation

enum SampleData {
    static let restaurants: [Restaurant] = [
        Restaurant(
            name: "فيلا روزيتا",
            cuisine: .italian,
            priceTier: .upscale,
            rating: 4.8,
            reviewCount: 612,
            heroImageName: "restaurant_italian",
            neighborhood: "وسط المدينة",
            address: "شارع الكرمة 12",
            latitude: 36.7538,
            longitude: 3.0588,
            description: "مطعم إيطالي يقدم المعكرونة الطازجة والأطباق الشهية في أجواء دافئة وأنيقة.",
            highlights: ["معكرونة طازجة", "قائمة نبيذ واسعة", "أجواء رومانسية"],
            openingTime: "12:00 م",
            closingTime: "11:00 م"
        ),
        Restaurant(
            name: "ساكورا هاوس",
            cuisine: .japanese,
            priceTier: .luxury,
            rating: 4.9,
            reviewCount: 894,
            heroImageName: "restaurant_japanese",
            neighborhood: "المرسى",
            address: "شارع الميناء 88",
            latitude: 36.7580,
            longitude: 3.0421,
            description: "سوشي دقيق ومطبخ ياباني راقٍ بإشراف شيف تدرب في طوكيو.",
            highlights: ["منضدة أوماكاسي", "صيد يومي طازج", "تنسيق الساكي"],
            openingTime: "5:00 م",
            closingTime: "10:30 م"
        ),
        Restaurant(
            name: "دار السوق",
            cuisine: .moroccan,
            priceTier: .moderate,
            rating: 4.7,
            reviewCount: 1043,
            heroImageName: "restaurant_moroccan",
            neighborhood: "المدينة القديمة",
            address: "زقاق القصبة 5",
            latitude: 36.7621,
            longitude: 3.0512,
            description: "أطباق مغربية مطهوة ببطء وشاي بالنعناع في فناء مليء بالفوانيس.",
            highlights: ["عزف عود ليال الجمعة", "مناسب للنباتيين", "جلوس في الفناء"],
            openingTime: "11:00 ص",
            closingTime: "12:00 ص"
        ),
        Restaurant(
            name: "الأرز والسماق",
            cuisine: .lebanese,
            priceTier: .moderate,
            rating: 4.6,
            reviewCount: 528,
            heroImageName: "restaurant_lebanese",
            neighborhood: "الضفة",
            address: "شارع الأرز 21",
            latitude: 36.7495,
            longitude: 3.0655,
            description: "مقبلات لبنانية ومشاوي وخبز طازج يُخبز يومياً.",
            highlights: ["مشاوي مشكلة", "أطباق عائلية", "تراس خارجي"],
            openingTime: "12:00 م",
            closingTime: "11:30 م"
        ),
        Restaurant(
            name: "لو بوتي شين",
            cuisine: .french,
            priceTier: .luxury,
            rating: 4.9,
            reviewCount: 356,
            heroImageName: "restaurant_french",
            neighborhood: "المدينة الراقية",
            address: "شارع السلام 3",
            latitude: 36.7702,
            longitude: 3.0489,
            description: "تقنية فرنسية كلاسيكية مع قائمة تذوق فقط، والحجز ضروري.",
            highlights: ["قائمة تذوق", "بتوصية ميشلان", "خبير نبيذ"],
            openingTime: "6:30 م",
            closingTime: "10:00 م"
        ),
        Restaurant(
            name: "الشبكة الزرقاء",
            cuisine: .seafood,
            priceTier: .upscale,
            rating: 4.7,
            reviewCount: 720,
            heroImageName: "restaurant_seafood",
            neighborhood: "المرسى",
            address: "ممشى الميناء 40",
            latitude: 36.7565,
            longitude: 3.0402,
            description: "صيد يومي مشوي على نار مفتوحة على مقربة من الميناء.",
            highlights: ["إطلالة على البحر", "صيد يومي طازج", "منضدة مأكولات نيئة"],
            openingTime: "12:00 م",
            closingTime: "11:00 م"
        ),
        Restaurant(
            name: "الجمرة والبلوط",
            cuisine: .steakhouse,
            priceTier: .luxury,
            rating: 4.8,
            reviewCount: 441,
            heroImageName: "restaurant_steakhouse",
            neighborhood: "وسط المدينة",
            address: "شارع الجمرة 77",
            latitude: 36.7549,
            longitude: 3.0601,
            description: "قطع لحم معتقة وقائمة ويسكي بُنيت على مدى عشرين عاماً.",
            highlights: ["لحم معتق", "قاعة طعام خاصة", "تنسيق الويسكي"],
            openingTime: "5:00 م",
            closingTime: "11:30 م"
        ),
        Restaurant(
            name: "تين الصباح",
            cuisine: .cafe,
            priceTier: .budget,
            rating: 4.5,
            reviewCount: 902,
            heroImageName: "restaurant_cafe",
            neighborhood: "المدينة القديمة",
            address: "زقاق التين 9",
            latitude: 36.7615,
            longitude: 3.0533,
            description: "قهوة مختصة ومعجنات طازجة وفطور طوال اليوم في مكان مشمس.",
            highlights: ["قهوة مختصة", "فطور طوال اليوم", "مناسب للعمل"],
            openingTime: "7:00 ص",
            closingTime: "6:00 م"
        ),
    ]
}
