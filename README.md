# That a Clocker

A large digital clock widget for the macOS desktop — a big Didot-serif time
display over a light blue gradient, with an optional row for your next few
calendar events. Built with SwiftUI and WidgetKit.

## Overview

That a Clocker consists of two targets:

- **ThatAClocker** — a small host app whose only job is to (optionally) sync
  upcoming calendar events into a shared App Group container, and to expose a
  toggle for turning that feature on or off.
- **ThatAClockerWidget** — the WidgetKit extension that renders the actual
  desktop widget, in the large (`systemLarge`) size only.

The clock face itself uses SwiftUI's `Text(date:style:.time)`, so it ticks
live every second regardless of the widget's own refresh cadence.

## Features

- **Large digital time + date**, set in Didot Bold/Italic — an editorial
  serif chosen as a more distinctive alternative to the usual system font.
- **Light blue gradient background**, applied via `.containerBackground(_:for:)`.
- **Optional "Up Next" row**, pulled from Calendar via EventKit, capped to
  the next 3 events in the following 24 hours.
- Intentionally minimal: no world clocks, no analog clock face.

## Requirements

- macOS 14 or later
- Xcode 15 or later
- A free Apple ID is enough to build and run locally. A paid Apple Developer
  Program membership is only needed to avoid re-signing the app every 7 days
  (see [Free-tier signing](#free-tier-signing) below) — otherwise optional.

## Project Structure

```
ThatAClocker (main app)
└── CalendarBridge   – EventKit fetch (24h ahead, top 3) → App Group UserDefaults
                        + a Toggle to enable/disable the whole feature at runtime

ThatAClockerWidget (widget extension)
├── Provider              – reads date + (optionally) events from the App Group
└── Large (systemLarge)
    ├── ClockWidgetView       – big Didot digital time + date, white on gradient

Shared/                – code and the Assets.xcassets catalog shared by both targets
scripts/               – optional rebuild automation, see below
```

## Building the Project

1. Open `ThatAClocker.xcodeproj` in Xcode.
2. Select the **ThatAClocker** scheme (not the widget extension) and a "My
   Mac" run destination.
3. Set **Signing & Capabilities → Team** on both targets to your Apple ID.
   Both targets share the App Group `group.app.developername.thataclocker`.
4. Build and run (⌘R). This launches the host app, which:
   - Shows a small window with a toggle for calendar sync.
   - On first run (if the toggle is on), prompts for Calendar access.
5. Add the widget: right-click the desktop → **Edit Widgets** → search "That
   a Clocker" → drag the large size onto the desktop.

**Live-editing the layout:** the `#Preview` block at the bottom of
`ClockWidgetView.swift` feeds Xcode's SwiftUI canvas (⌥⌘P) two sample
timelines (with and without events) — faster to iterate on than reinstalling
the widget each time.

## Free-Tier Signing

With a free (non-paid) Apple ID, Xcode's auto-managed provisioning profile
expires after 7 days, and the widget will silently stop updating until
rebuilt. `scripts/` contains optional automation to avoid thinking about
this:

- `rebuild.sh` runs `xcodebuild … -allowProvisioningUpdates`, which
  renews the profile, then reinstalls to `~/Applications` and relaunches.
- rebuild.plist` is a LaunchAgent that runs
  the script every 6 days automatically.

To install: make sure Xcode → Settings → Accounts has the Apple ID signed
in, then

To uninstall: `launchctl unload ~/Library/LaunchAgents/app.yair.thataclocker.rebuild.plist`
then delete that file.

A paid Apple Developer Program membership removes the need for any of this.
