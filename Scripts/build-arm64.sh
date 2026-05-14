#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIGURATION="${CONFIGURATION:-Release}"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-$ROOT/build/DerivedData}"
ARCHIVE_DIR="${ARCHIVE_DIR:-$ROOT/Releases}"
APP_PATH="$DERIVED_DATA_PATH/Build/Products/$CONFIGURATION/Dozer.app"
ZIP_PATH="$ARCHIVE_DIR/Dozer-arm64.zip"
CARTHAGE_XCCONFIG="$ROOT/build/carthage-arm64.xcconfig"
CARTHAGE_BIN_DIR="$ROOT/build/carthage-bin"
ARM_ENTITLEMENTS="$ROOT/build/dozer-arm64.entitlements"
CARTHAGE_FRAMEWORKS=(
  LaunchAtLogin
  Defaults
  Preferences
  MASShortcut
  Sparkle
)

cd "$ROOT"

if ! xcodebuild -version >/dev/null 2>&1; then
  echo "xcodebuild requires a full Xcode installation. Select it with xcode-select before building." >&2
  exit 69
fi

if [[ ! -d Dozer.xcodeproj ]]; then
  if ! command -v xcodegen >/dev/null 2>&1; then
    echo "Dozer.xcodeproj is missing and xcodegen is not installed." >&2
    exit 69
  fi
  xcodegen
fi

mkdir -p "$CARTHAGE_BIN_DIR"
printf '#!/usr/bin/env bash\nexit 0\n' > "$CARTHAGE_BIN_DIR/swiftgen"
printf '#!/usr/bin/env bash\nexit 0\n' > "$CARTHAGE_BIN_DIR/swiftlint"
chmod +x "$CARTHAGE_BIN_DIR/swiftgen" "$CARTHAGE_BIN_DIR/swiftlint"

{
  printf '<?xml version="1.0" encoding="UTF-8"?>\n'
  printf '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n'
  printf '<plist version="1.0">\n'
  printf '<dict>\n'
  printf '  <key>com.apple.security.cs.disable-library-validation</key>\n'
  printf '  <true/>\n'
  printf '</dict>\n'
  printf '</plist>\n'
} > "$ARM_ENTITLEMENTS"

missing_carthage_framework=false
for framework in "${CARTHAGE_FRAMEWORKS[@]}"; do
  if [[ ! -d "Carthage/Build/$framework.xcframework" ]]; then
    missing_carthage_framework=true
    break
  fi
done

if [[ "$missing_carthage_framework" == true ]]; then
  if ! command -v carthage >/dev/null 2>&1; then
    echo "Carthage XCFrameworks are missing and carthage is not installed." >&2
    exit 69
  fi
  mkdir -p "$(dirname "$CARTHAGE_XCCONFIG")"
  {
    printf 'MACOSX_DEPLOYMENT_TARGET = 11.0\n'
    printf 'GCC_TREAT_WARNINGS_AS_ERRORS = NO\n'
    printf 'CODE_SIGNING_ALLOWED = NO\n'
  } > "$CARTHAGE_XCCONFIG"

  PATH="$CARTHAGE_BIN_DIR:$PATH" XCODE_XCCONFIG_FILE="$CARTHAGE_XCCONFIG" carthage bootstrap --cache-builds --platform macOS --use-xcframeworks
fi

PATH="$CARTHAGE_BIN_DIR:$PATH" xcodebuild \
  -project Dozer.xcodeproj \
  -scheme Dozer \
  -configuration "$CONFIGURATION" \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  ARCHS=arm64 \
  ONLY_ACTIVE_ARCH=NO \
  CODE_SIGN_IDENTITY=- \
  CODE_SIGN_ENTITLEMENTS="$ARM_ENTITLEMENTS" \
  CODE_SIGNING_ALLOWED=YES \
  build

test -x "$APP_PATH/Contents/MacOS/Dozer"
if ! lipo "$APP_PATH/Contents/MacOS/Dozer" -verify_arch arm64; then
  echo "Built app is not arm64: $APP_PATH" >&2
  exit 70
fi

mkdir -p "$ARCHIVE_DIR"
rm -f "$ZIP_PATH"
ditto -c -k --norsrc --noextattr --keepParent "$APP_PATH" "$ZIP_PATH"

echo "Built: $APP_PATH"
echo "Archive: $ZIP_PATH"
