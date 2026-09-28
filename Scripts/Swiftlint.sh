export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
if command -v swiftlint >/dev/null; then
  swiftlint --lenient
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
