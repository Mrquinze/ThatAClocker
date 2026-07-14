import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage(AppGroup.calendarEnabledKey, store: UserDefaults(suiteName: AppGroup.id))
    private var calendarEnabled = true

    @State private var status = "Not synced yet"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("That a Clocker")
                .font(.title2.bold())
                .fontDesign(.rounded)

            Text("Add the widget from Notification Center → Edit Widgets → \"That a Clocker\", then drag the large size onto your desktop.")
                .font(.callout)
                .foregroundStyle(.secondary)

            Divider()

            Toggle("Show upcoming calendar events", isOn: $calendarEnabled)
                .onChange(of: calendarEnabled) { _, _ in
                    WidgetCenter.shared.reloadAllTimelines()
                }

            Text("If calendar sync ever misbehaves, switch this off — the widget falls back to a clean clock with no calendar row. No need to touch any code.")
                .font(.caption)
                .foregroundStyle(.tertiary)

            Button("Grant Calendar Access & Sync Now") {
                CalendarBridge.requestAccessAndSync { result in
                    status = result
                }
            }
            .disabled(!calendarEnabled)

            Text(status)
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(24)
        .frame(width: 420, height: 280)
        .onAppear {
            if calendarEnabled {
                CalendarBridge.requestAccessAndSync { result in
                    status = result
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
