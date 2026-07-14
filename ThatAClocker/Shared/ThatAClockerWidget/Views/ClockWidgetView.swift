import SwiftUI
import WidgetKit

struct ClockWidgetView: View {
    let entry: ClockEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer(minLength: 0)

            Text(entry.date, style: .time)
                .font(.custom("Didot-Bold", size: 92))
                .minimumScaleFactor(0.4)
                .lineLimit(1)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.15), radius: 6, y: 2)

            Text(entry.date, style: .date)
                .font(.custom("Didot-Italic", size: 24))
                .foregroundStyle(.white.opacity(0.85))

            Spacer(minLength: 0)

            CalendarEventsSection(events: entry.upcomingEvents)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
    }
}

#Preview(as: .systemLarge) {
    ThatAClockerWidget()
} timeline: {
    ClockEntry(date: .now, upcomingEvents: [])
    ClockEntry(date: .now, upcomingEvents: ["10:00 AM  Standup", "2:00 PM  Design review"])
}
