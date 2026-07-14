import EventKit
import WidgetKit
import Foundation

// Self-contained calendar integration. To rip it out entirely if something
// misbehaves: delete this file, remove the "Grant Calendar Access" button
// and its onAppear call in ContentView.swift, delete CalendarEventsSection.swift
// in the widget target, and drop NSCalendarsFullAccessUsageDescription from
// Info.plist. Nothing else in the app depends on this.
//
// Day-to-day, the Toggle in ContentView is the easy off-switch — it doesn't
// require removing any code.
enum CalendarBridge {
    private static let store = EKEventStore()

    static func requestAccessAndSync(completion: @escaping (String) -> Void) {
        store.requestFullAccessToEvents { granted, error in
            DispatchQueue.main.async {
                guard granted else {
                    completion(error?.localizedDescription ?? "Calendar access denied")
                    return
                }
                syncUpcomingEvents()
                let time = DateFormatter.localizedString(from: .now, dateStyle: .none, timeStyle: .short)
                completion("Synced at \(time)")
            }
        }
    }

    private static func syncUpcomingEvents() {
        let now = Date()
        guard let end = Calendar.current.date(byAdding: .hour, value: 24, to: now) else { return }
        let predicate = store.predicateForEvents(withStart: now, end: end, calendars: nil)
        let events = store.events(matching: predicate)
            .sorted { $0.startDate < $1.startDate }
            .prefix(3)
            .map { event -> String in
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                return "\(formatter.string(from: event.startDate))  \(event.title ?? "Untitled")"
            }

        UserDefaults(suiteName: AppGroup.id)?.set(Array(events), forKey: AppGroup.upcomingEventsKey)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
