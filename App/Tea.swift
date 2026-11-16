import SwiftUI

struct Tea: Identifiable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let seconds: Int
    let celsius: Int
    let note: String
    let hex: UInt32

    var color: Color { Color(hex: hex) }

    static let all: [Tea] = [
        Tea(id: "green", name: "Green", symbol: "leaf.fill", seconds: 120, celsius: 80,
            note: "Grassy and bright. Cooler water keeps it from turning bitter.", hex: 0x5DB56A),
        Tea(id: "black", name: "Black", symbol: "flame.fill", seconds: 210, celsius: 95,
            note: "Bold and malty. Hot water pulls out its full body.", hex: 0xB5523B),
        Tea(id: "white", name: "White", symbol: "sparkles", seconds: 240, celsius: 85,
            note: "Delicate and sweet. Be gentle with the heat.", hex: 0xC4A95A),
        Tea(id: "oolong", name: "Oolong", symbol: "drop.fill", seconds: 180, celsius: 90,
            note: "Floral and toasty. Great for several infusions.", hex: 0xD38A3F),
        Tea(id: "puerh", name: "Pu-erh", symbol: "mountain.2.fill", seconds: 180, celsius: 100,
            note: "Earthy and deep. Rinse the leaves first for a cleaner cup.", hex: 0x8C6A52),
        Tea(id: "herbal", name: "Herbal", symbol: "moon.stars.fill", seconds: 300, celsius: 100,
            note: "Soothing and caffeine free. Let it steep fully.", hex: 0x9E6FBA)
    ]
}
