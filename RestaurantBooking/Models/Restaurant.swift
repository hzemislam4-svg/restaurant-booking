import Foundation
import CoreGraphics

struct Restaurant: Identifiable, Hashable {
    let id: String
    let name: String
    let cuisine: String
    let area: String
    let rating: Double
    let price: String
    let distance: String
    let hours: String
    let reviewCount: Int
    let mapX: CGFloat
    let mapY: CGFloat
    let mapLat: Double
    let mapLng: Double
    let description: String

    var ratingStr: String { String(format: "%.1f", rating) }
}
