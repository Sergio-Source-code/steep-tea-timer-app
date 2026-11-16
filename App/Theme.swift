import SwiftUI
import UIKit

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }

    static func dynamic(light: UInt32, dark: UInt32) -> Color {
        let provider: (UITraitCollection) -> UIColor = { (traits: UITraitCollection) -> UIColor in
            let h: UInt32 = traits.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                red: CGFloat((h >> 16) & 0xFF) / 255,
                green: CGFloat((h >> 8) & 0xFF) / 255,
                blue: CGFloat(h & 0xFF) / 255,
                alpha: 1
            )
        }
        return Color(UIColor(dynamicProvider: provider))
    }
}

enum Theme {
    static let accentTop = Color(hex: 0x8FD694)
    static let accentBottom = Color(hex: 0x2E8B57)

    static let backgroundTop = Color.dynamic(light: 0xF2F8EC, dark: 0x12281D)
    static let backgroundBottom = Color.dynamic(light: 0xD9EAD3, dark: 0x06120C)

    static let card = Color.primary.opacity(0.07)
    static let track = Color.primary.opacity(0.10)

    static var background: LinearGradient {
        LinearGradient(colors: [backgroundTop, backgroundBottom], startPoint: .top, endPoint: .bottom)
    }

    static var accentGradient: LinearGradient {
        LinearGradient(colors: [accentTop, accentBottom], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
