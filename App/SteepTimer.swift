import SwiftUI
import UserNotifications

@MainActor
@Observable
final class SteepTimer {
    enum Phase: Equatable {
        case idle, running, paused, done
    }

    var tea: Tea
    var duration: Int
    var remaining: TimeInterval
    var phase: Phase = .idle

    @ObservationIgnored private var endDate: Date?
    @ObservationIgnored private var ticker: Timer?

    init() {
        let first: Tea = Tea.all[0]
        tea = first
        duration = first.seconds
        remaining = TimeInterval(first.seconds)
    }

    var progress: Double {
        guard duration > 0 else { return 0 }
        return min(1, max(0, 1 - remaining / Double(duration)))
    }

    var isDone: Bool { phase == .done }

    var timeText: String {
        let total: Int = Int(remaining.rounded(.up))
        return String(format: "%d:%02d", total / 60, total % 60)
    }

    func select(_ newTea: Tea) {
        stopTicker()
        cancelNotification()
        tea = newTea
        duration = newTea.seconds
        remaining = TimeInterval(duration)
        phase = .idle
    }

    func adjust(by delta: Int) {
        guard phase == .idle else { return }
        duration = min(1200, max(15, duration + delta))
        remaining = TimeInterval(duration)
    }

    func start() {
        if phase == .done { reset() }
        guard phase == .idle || phase == .paused else { return }
        endDate = Date().addingTimeInterval(remaining)
        phase = .running
        scheduleNotification()
        startTicker()
    }

    func pause() {
        guard phase == .running else { return }
        tick()
        guard phase == .running else { return }
        stopTicker()
        cancelNotification()
        phase = .paused
    }

    func reset() {
        stopTicker()
        cancelNotification()
        remaining = TimeInterval(duration)
        phase = .idle
    }

    private func tick() {
        guard let endDate else { return }
        remaining = max(0, endDate.timeIntervalSinceNow)
        if remaining <= 0 {
            stopTicker()
            phase = .done
        }
    }

    private func startTicker() {
        stopTicker()
        ticker = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    private func stopTicker() {
        ticker?.invalidate()
        ticker = nil
    }

    private func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
        let content = UNMutableNotificationContent()
        content.title = "Your \(tea.name) tea is ready"
        content.body = "Time to remove the leaves and enjoy."
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, remaining), repeats: false)
        let request = UNNotificationRequest(identifier: "steep.done", content: content, trigger: trigger)
        center.add(request)
    }

    private func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["steep.done"])
    }
}
