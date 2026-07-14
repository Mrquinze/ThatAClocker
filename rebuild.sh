#!/bin/zsh
set -euo pipefail

# Rebuilds ThatAClocker with a free (non-paid) Apple ID and reinstalls it,
# which renews the auto-managed provisioning profile before its 7-day
# expiry silently blanks out the widget. Meant to run unattended via the
# LaunchAgent in this same folder — see SETUP.md for install steps.
#
# Requires: Xcode installed, and signed into the same Apple ID under
# Xcode → Settings → Accounts (so -allowProvisioningUpdates can renew
# the profile without an interactive prompt).

PROJECT_PATH="$HOME/Documents/ThatAClocker/ThatAClocker.xcodeproj"
SCHEME="ThatAClocker"
APP_NAME="ThatAClocker.app"
INSTALL_DIR="$HOME/Applications"

if [[ ! -d "$PROJECT_PATH" ]]; then
    echo "$(date): $PROJECT_PATH not found — create the Xcode project first (see SETUP.md)." >&2
    exit 1
fi

BUILD_DIR=$(mktemp -d)
trap 'rm -rf "$BUILD_DIR"' EXIT

echo "$(date): building $SCHEME..."
xcodebuild \
    -project "$PROJECT_PATH" \
    -scheme "$SCHEME" \
    -destination 'platform=macOS' \
    -configuration Debug \
    -derivedDataPath "$BUILD_DIR" \
    -allowProvisioningUpdates \
    build

BUILT_APP=$(find "$BUILD_DIR/Build/Products" -maxdepth 2 -name "$APP_NAME" -print -quit)
if [[ -z "$BUILT_APP" ]]; then
    echo "$(date): build succeeded but $APP_NAME wasn't found under $BUILD_DIR" >&2
    exit 1
fi

echo "$(date): reinstalling to $INSTALL_DIR..."
osascript -e "tell application \"$APP_NAME:r\" to quit" >/dev/null 2>&1 || true
pkill -f "$INSTALL_DIR/$APP_NAME" >/dev/null 2>&1 || true

mkdir -p "$INSTALL_DIR"
rm -rf "$INSTALL_DIR/$APP_NAME"
cp -R "$BUILT_APP" "$INSTALL_DIR/$APP_NAME"

open "$INSTALL_DIR/$APP_NAME"
echo "$(date): done — relaunched $INSTALL_DIR/$APP_NAME"
