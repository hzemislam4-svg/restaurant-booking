# حجز المطاعم — Restaurant Booking

تطبيق iOS أصلي (SwiftUI) لحجز مقاعد المطاعم، مطابق لتصميم «حجز المطاعم.dc.html». واجهة عربية RTL، خط Tajawal، بموضوع داكن بألوان قابلة للتبديل.

**النطاق الحالي:** حجز المقعد فقط (بدون طلب طعام). أسماء المطاعم بيانات تجريبية بانتظار بياناتك.

## الشاشات
- الرئيسية — بحث + فلتر مطبخ + مبدّل شبكة/قائمة/مميز
- تفاصيل المطعم + تقييمات
- تفاصيل الحجز (تاريخ / عدد أشخاص / وقت)
- اختيار الطاولة (مخطط طاولات: متاح/محجوز/مختار)
- تأكيد الحجز
- الخريطة (Google Maps مع علامات)
- المفضلة
- تسجيل الدخول (جوال/بريد + تسجيل دخول Google فعلي)
- حسابي + مبدّل لون التطبيق
- العضوية المميزة + بوابة دفع (واجهة فقط)
- حجوزاتي (قادم/ملغي + إلغاء)

## التقنيات
- SwiftUI، RTL، خط Tajawal مضمّن
- GoogleSignIn SDK عبر SwiftPM (تسجيل دخول Google فعلي)
- Google Maps SDK عبر SwiftPM (خريطة فعلية + علامات + نافذة معلومات)
- XcodeGen لإنشاء المشروع
- GitHub Actions لبناء IPA على macOS

## بناء IPA عبر GitHub Actions
1. ادفع الكود إلى `main`.
2. من صفحة المستودع: `Actions` → `Build IPA` → `Run workflow`.
3. نزّل القطعة `RestaurantBooking-ipa` من أسفل الـ run.

## تفعيل خرائط Google وتسجيل الدخول
أضف الـ secrets التالية في `Settings → Secrets and variables → Actions`:

| Secret | القيمة |
|--------|--------|
| `GOOGLE_MAPS_API_KEY` | مفتاح API مع تفعيل «Maps SDK for iOS» في Google Cloud Console |
| `GOOGLE_CLIENT_ID` | OAuth Client ID من نوع iOS من Google Cloud Console |

- Client ID يكون بصيغة `1234567890-xxxx.apps.googleusercontent.com`.
- **مهم:** في إعدادات OAuth client سجّل الـ bundle ID `com.restaurantbooking.app` في حقل «Bundle ID» — وإلا لن يعمل تسجيل الدخول.
- الـ workflow يحسب تلقائياً الـ reversed client ID (`com.googleusercontent.apps.<الرقم>`) من Client ID ويحقنه في `Info.plist`.
- بدون الـ secrets يبني التطبيق بنجاح، لكن الخريطة تعرض نسخة تجريبية وتسجيل الدخول يعمل بوضع تجريبي (ديمو).

## التثبيت على جهازك (Sideloadly)
1. نزّل IPA من القطع (artifacts).
2. ثبّته عبر **Sideloadly** على Windows مع معرف Apple مجاني.
3. استخدم الـ bundle ID نفسه `com.restaurantbooking.app` عند إعادة التوقيع.

## البناء محلياً
```bash
brew install xcodegen
xcodegen generate
open RestaurantBooking.xcodeproj
```
