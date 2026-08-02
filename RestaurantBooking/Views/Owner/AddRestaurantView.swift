//
//  AddRestaurantView.swift
//  RestaurantBooking
//
//  Form for a restaurant owner to publish a new listing. Saves to
//  Firestore via RestaurantRepository, and uploads any selected photos
//  to Firebase Storage via StorageService - both real, both free tier.
//

import SwiftUI
import PhotosUI

struct AddRestaurantView: View {
    @EnvironmentObject private var auth: FirebaseAuthService
    @EnvironmentObject private var restaurantRepo: RestaurantRepository
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var cuisine: Cuisine = .other
    @State private var priceTier: PriceTier = .moderate
    @State private var neighborhood = ""
    @State private var address = ""
    @State private var description = ""
    @State private var openingTime = "12:00 PM"
    @State private var closingTime = "11:00 PM"
    @State private var highlightsText = ""

    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []

    @State private var isSaving = false
    @State private var errorMessage: String?

    private var canSave: Bool {
        !name.isEmpty && !neighborhood.isEmpty && !address.isEmpty && !description.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("الأساسيات") {
                    TextField("اسم المطعم", text: $name)
                    Picker("نوع المطبخ", selection: $cuisine) {
                        ForEach(Cuisine.allCases) { c in
                            Text("\(c.icon) \(c.arabicName)").tag(c)
                        }
                    }
                    Picker("فئة السعر", selection: $priceTier) {
                        ForEach(PriceTier.allCases, id: \.self) { tier in
                            Text(tier.symbol).tag(tier)
                        }
                    }
                }

                Section("الموقع") {
                    TextField("الحي", text: $neighborhood)
                    TextField("العنوان الكامل", text: $address)
                    Text("ملاحظة: تحديد موقع دقيق على الخريطة غير مرفق بعد في هذا النموذج — راجع README لخطوة الترميز الجغرافي.")
                        .font(.caption2)
                        .foregroundStyle(AppColor.textTertiary)
                }

                Section("أوقات العمل") {
                    TextField("وقت الفتح (مثلاً 12:00 م)", text: $openingTime)
                    TextField("وقت الإغلاق (مثلاً 11:00 م)", text: $closingTime)
                }

                Section("نبذة") {
                    TextField("الوصف", text: $description, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                    TextField("المميزات، مفصولة بفواصل", text: $highlightsText, axis: .vertical)
                        .lineLimit(2, reservesSpace: true)
                }

                Section("الصور") {
                    PhotosPicker(selection: $selectedPhotoItems, maxSelectionCount: 5, matching: .images) {
                        Label("اختر الصور", systemImage: "photo.badge.plus")
                    }
                    .onChange(of: selectedPhotoItems) { _, newItems in
                        Task { await loadImages(from: newItems) }
                    }

                    if !selectedImages.isEmpty {
                        ScrollView(.horizontal) {
                            HStack(spacing: 8) {
                                ForEach(Array(selectedImages.enumerated()), id: \.offset) { _, image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                    }
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(AppColor.danger)
                    }
                }
            }
            .navigationTitle("إضافة مطعم")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("إلغاء") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isSaving {
                        ProgressView()
                    } else {
                        Button("نشر") { Task { await save() } }
                            .disabled(!canSave)
                    }
                }
            }
        }
    }

    private func loadImages(from items: [PhotosPickerItem]) async {
        var images: [UIImage] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                images.append(image)
            }
        }
        selectedImages = images
    }

    private func save() async {
        guard let ownerId = auth.currentUser?.uid else { return }
        isSaving = true
        errorMessage = nil

        var restaurant = Restaurant(
            ownerId: ownerId,
            name: name,
            cuisine: cuisine,
            priceTier: priceTier,
            neighborhood: neighborhood,
            address: address,
            // Placeholder coordinate - swap for a real geocode of `address`
            // using CLGeocoder before publishing in production.
            latitude: 36.7538,
            longitude: 3.0588,
            description: description,
            highlights: highlightsText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
            openingTime: openingTime,
            closingTime: closingTime
        )

        do {
            // Create the document first so uploaded photos have a
            // restaurantId to file under in Storage.
            try await restaurantRepo.createRestaurant(restaurant)

            var uploadedURLs: [String] = []
            for image in selectedImages {
                let url = try await StorageService.shared.uploadRestaurantPhoto(image, restaurantId: restaurant.id)
                uploadedURLs.append(url)
            }
            if !uploadedURLs.isEmpty {
                restaurant.imageURLs = uploadedURLs
                try await restaurantRepo.updateRestaurant(restaurant)
            }

            isSaving = false
            dismiss()
        } catch {
            isSaving = false
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    AddRestaurantView()
        .environmentObject(FirebaseAuthService())
        .environmentObject(RestaurantRepository())
}
