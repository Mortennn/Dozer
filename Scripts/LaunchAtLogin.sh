#!/bin/sh
set -eu
resources="$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/LaunchAtLogin.framework/Resources"
helper="$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/Library/LoginItems/LaunchAtLoginHelper.app"
identity="${EXPANDED_CODE_SIGN_IDENTITY:--}"
mkdir -p "$(dirname "$helper")"
ditto "$resources/LaunchAtLoginHelper.app" "$helper"
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $PRODUCT_BUNDLE_IDENTIFIER-LaunchAtLoginHelper" "$helper/Contents/Info.plist"
codesign --force --options runtime --entitlements "$resources/LaunchAtLogin.entitlements" --sign "$identity" "$helper"
codesign --force --options runtime --entitlements "$resources/LaunchAtLogin.entitlements" --sign "$identity" "$resources/LaunchAtLoginHelper.app"
codesign --force --sign "$identity" "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/LaunchAtLogin.framework"
