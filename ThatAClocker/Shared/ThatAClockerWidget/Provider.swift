import WidgetKit
import Foundation

struct Provider: TimelineProvider {
    private let defaults = UserDefaults(suiteName: AppGroup.id)

    func placeholder(in context: Context) -> ClockEntry {
        ClockEntry(date: .now, upcomingEvents: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (ClockEntry) -> Void) {
        completion(ClockEntry(date: .now, upcomingEvents: currentEvents()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ClockEntry>) -> Void) {
        let entry = ClockEntry(date: .now, upcomingEvents: currentEvents())
        // The big digital time self-updates every second via Text(date:style:)
        // regardless of this cadence; 30 min just keeps the date/events fresh.
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }

    // Defaults to enabled: only reads false once ContentView's Toggle has
    // explicitly written it, so a not-yet-launched host app still shows events.
    private func calendarEnabled() -> Bool {
        guard let defaults, defaults.object(forKey: AppGroup.calendarEnabledKey) != nil else { return true }
        return defaults.bool(forKey: AppGroup.calendarEnabledKey)
    }

    private func currentEvents() -> [String] {
        guard calendarEnabled() else { return [] }
        return defaults?.stringArray(forKey: AppGroup.upcomingEventsKey) ?? []
    }
}
