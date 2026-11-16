import SwiftUI

struct TeaPicker: View {
    let selected: Tea
    let onSelect: (Tea) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Tea.all) { tea in
                    TeaChip(tea: tea, isSelected: tea == selected) {
                        onSelect(tea)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
        }
    }
}

struct TeaChip: View {
    let tea: Tea
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: tea.symbol)
                    .font(.title2)
                    .frame(height: 28)
                Text(tea.name)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
            }
            .foregroundStyle(isSelected ? Color.white : Color.primary)
            .frame(width: 82, height: 82)
            .background(background)
            .scaleEffect(isSelected ? 1.05 : 1)
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(isSelected ? AnyShapeStyle(tea.color.gradient) : AnyShapeStyle(Theme.card))
    }
}
