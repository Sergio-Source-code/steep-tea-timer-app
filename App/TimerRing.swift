import SwiftUI

struct TimerRing: View {
    let model: SteepTimer

    private var statusText: String {
        switch model.phase {
        case .idle: return "Ready to steep"
        case .running: return "Steeping"
        case .paused: return "Paused"
        case .done: return "Your tea is ready"
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Theme.track, lineWidth: 18)
            Circle()
                .trim(from: 0, to: model.phase == .idle ? 1 : 1 - model.progress)
                .stroke(
                    LinearGradient(colors: [model.tea.color, Theme.accentTop], startPoint: .top, endPoint: .bottom),
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.1), value: model.progress)
            VStack(spacing: 6) {
                Image(systemName: model.isDone ? "checkmark.circle.fill" : model.tea.symbol)
                    .font(.title2)
                    .foregroundStyle(model.tea.color)
                    .contentTransition(.symbolEffect(.replace))
                Text(model.timeText)
                    .font(.system(size: 62, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .contentTransition(.numericText())
                Text(statusText)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 280, height: 280)
        .scaleEffect(model.isDone ? 1.04 : 1)
        .animation(.spring(response: 0.5, dampingFraction: 0.55), value: model.isDone)
    }
}
