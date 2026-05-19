SWIFTLINT=/opt/homebrew/bin/swiftlint
if [ -f "$SWIFTLINT" ]; then
  "$SWIFTLINT" --lenient
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
