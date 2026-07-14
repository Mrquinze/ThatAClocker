import WidgetKit
import SwiftUI

struct ThatAClockerWidget: Widget {
    static let kind = "ThatAClockerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: Self.kind, provider: Provider()) { entry in
            ClockWidgetView(entry: entry)
                .containerBackground(
                    LinearGradient(
                        colors: [
                            Color(red: 0.70, green: 0.87, blue: 1.00),
                            Color(red: 0.36, green: 0.66, blue: 0.96)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    for: .widget
                )
        }
        .configurationDisplayName("That a Clocker")
        .description("A large digital clock for your desktop.")
        .supportedFamilies([.systemLarge])
    }
}

@main
struct ThatAClockerWidgetBundle: WidgetBundle {
    var body: some Widget {
        ThatAClockerWidget()
    }
}
