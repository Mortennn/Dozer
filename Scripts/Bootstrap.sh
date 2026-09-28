#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

carthage bootstrap --no-build
# Current SwiftLint reports style errors in this pinned dependency's example.
# Keep those diagnostics as warnings without editing dependency source files.
sed -i '' 's/    swiftlint\\n/    swiftlint --lenient\\n/g' \
    Carthage/Checkouts/Preferences/Preferences.xcodeproj/project.pbxproj
XCODE_XCCONFIG_FILE="$PWD/Configs/Dependencies.xcconfig" \
    carthage build Defaults Preferences LaunchAtLogin MASShortcut \
    --platform macOS --no-use-binaries --cache-builds

# Sparkle 1.27.3 supplies both arm64 and x86_64 while preserving the SUUpdater API.
# Its signed helper tools come from the upstream release rather than a local
# Carthage archive, which cannot sign them with a Developer ID.
mkdir -p .build Carthage/Build/Mac
curl --fail --location --silent --show-error \
    https://github.com/sparkle-project/Sparkle/releases/download/1.27.3/Sparkle-1.27.3.tar.xz \
    --output .build/Sparkle-1.27.3.tar.xz
printf '%s\n' 'b4c70198aba86a65dc04550fbd0a97243a9ba3b98d73d138c877347f27920952  .build/Sparkle-1.27.3.tar.xz' | shasum -a 256 --check
tar -xJf .build/Sparkle-1.27.3.tar.xz -C Carthage/Build/Mac Sparkle.framework Sparkle.framework.dSYM
