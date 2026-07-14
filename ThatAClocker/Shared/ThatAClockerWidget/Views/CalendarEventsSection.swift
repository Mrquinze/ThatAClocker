import SwiftUI

// Self-contained: delete this file and its single call site in
// ClockWidgetView.swift to remove calendar integration from the widget.
// Renders nothing when there are no events, so it's already a no-op if the
// host app's Toggle is switched off or access was never granted.
struct CalendarEventsSection: View {
    let events: [String]

    var body: some View {
        if !events.isEmpty {
            Divider()
                .background(Color.white.opacity(0.3))
            VStack(alignment: .leading, spacing: 4) {
                Label("UP NEXT", systemImage: "calendar")
                    .font(.caption2.bold())
                    .foregroundStyle(.white.opacity(0.7))
                ForEach(events, id: \.self) { event in
                    Text(event)
                        .font(.caption)
                        .lineLimit(1)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
        }
    }
}
