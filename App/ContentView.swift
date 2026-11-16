import SwiftUI

struct ContentView: View {
    @State private var model = SteepTimer()

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 24) {
                    header
                    TeaPicker(selected: model.tea) { (tea: Tea) in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            model.select(tea)
                        }
                    }
                    TimerRing(model: model)
                        .padding(.vertical, 8)
                    details
                    controls
                }
                .padding(.vertical, 16)
            }
        }
        .sensoryFeedback(.selection, trigger: model.tea)
        .sensoryFeedback(.impact, trigger: model.phase)
        .sensoryFeedback(.success, trigger: model.isDone)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Steep")
                .font(.system(size: 38, weight: .bold, design: .rounded))
            Text("Brew every cup just right")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }

    private var details: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Steep time")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Text(durationText)
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .monospacedDigit()
                }
                Spacer()
                adjustButton(symbol: "minus", delta: -15)
                adjustButton(symbol: "plus", delta: 15)
            }
            .cardStyle()

            HStack(alignment: .top, spacing: 14) {
                VStack(spacing: 2) {
                    Image(systemName: "thermometer.medium")
                        .font(.title3)
                        .foregroundStyle(model.tea.color)
                    Text("\(model.tea.celsius)°C")
                        .font(.system(.headline, design: .rounded, weight: .bold))
                }
                .frame(width: 64)
                Text(model.tea.note)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .cardStyle()
        }
        .padding(.horizontal, 20)
    }

    private var durationText: String {
        String(format: "%d:%02d", model.duration / 60, model.duration % 60)
    }

    private func adjustButton(symbol: String, delta: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                model.adjust(by: delta)
            }
        } label: {
            Image(systemName: symbol)
                .font(.headline)
                .frame(width: 44, height: 44)
                .background(Theme.card, in: Circle())
        }
        .buttonStyle(.plain)
        .disabled(model.phase != .idle)
        .opacity(model.phase == .idle ? 1 : 0.35)
    }

    private var controls: some View {
        HStack(spacing: 14) {
            Button(action: primaryAction) {
                Label(primaryTitle, systemImage: primarySymbol)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 58)
                    .background(Theme.accentGradient, in: Capsule())
                    .shadow(color: Theme.accentBottom.opacity(0.4), radius: 12, y: 6)
            }
            .buttonStyle(.plain)

            if model.phase == .running || model.phase == .paused {
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        model.reset()
                    }
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title3.weight(.semibold))
                        .frame(width: 58, height: 58)
                        .background(Theme.card, in: Circle())
                }
                .buttonStyle(.plain)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 20)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: model.phase)
    }

    private var primaryTitle: String {
        switch model.phase {
        case .idle: return "Start Steeping"
        case .running: return "Pause"
        case .paused: return "Resume"
        case .done: return "Brew Again"
        }
    }

    private var primarySymbol: String {
        switch model.phase {
        case .idle: return "play.fill"
        case .running: return "pause.fill"
        case .paused: return "play.fill"
        case .done: return "arrow.clockwise"
        }
    }

    private func primaryAction() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if model.phase == .running {
                model.pause()
            } else {
                model.start()
            }
        }
    }
}
