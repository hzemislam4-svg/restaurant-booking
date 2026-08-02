//
//  StorageService.swift
//  RestaurantBooking
//
//  Uploads restaurant photos to Firebase Storage so they're visible to
//  every customer, not just stored on the owner's own phone.
//
//  Storage free (Spark) tier: 5 GB stored, 1 GB/day downloaded - fine
//  for a handful of restaurants with a few photos each. No billing
//  account required.
//

import Foundation
import FirebaseStorage
import UIKit

enum StorageError: Error, LocalizedError {
    case compressionFailed
    case uploadFailed(String)

    var errorDescription: String? {
        switch self {
        case .compressionFailed: return "Could not prepare the photo for upload."
        case .uploadFailed(let msg): return "Upload failed: \(msg)"
        }
    }
}

final class StorageService {
    static let shared = StorageService()
    private let storage = Storage.storage()

    /// Uploads one photo and returns its public download URL.
    func uploadRestaurantPhoto(_ image: UIImage, restaurantId: String) async throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            throw StorageError.compressionFailed
        }

        let filename = "\(UUID().uuidString).jpg"
        let ref = storage.reference().child("restaurants/\(restaurantId)/\(filename)")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        do {
            _ = try await ref.putDataAsync(data, metadata: metadata)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            throw StorageError.uploadFailed(error.localizedDescription)
        }
    }

    func deletePhoto(url: String) async {
        // Best-effort cleanup - a failed delete here shouldn't block the
        // rest of the app, so errors are swallowed intentionally.
        guard let ref = try? storage.reference(forURL: url) else { return }
        try? await ref.delete()
    }
}
