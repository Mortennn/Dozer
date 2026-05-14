set -euo pipefail

HELPER_SCRIPT=""

for candidate in \
  "./Carthage/Build/LaunchAtLogin.xcframework/macos-arm64_x86_64/LaunchAtLogin.framework/Resources/copy-helper.sh" \
  "./Carthage/Build/LaunchAtLogin.xcframework/macos-arm64/LaunchAtLogin.framework/Resources/copy-helper.sh" \
  "./Carthage/Build/Mac/LaunchAtLogin.framework/Resources/copy-helper.sh"
do
  if [[ -x "$candidate" ]]; then
    HELPER_SCRIPT="$candidate"
    break
  fi
done

if [[ -z "$HELPER_SCRIPT" ]]; then
  echo "warning: LaunchAtLogin helper script not found; skipping login item helper copy"
  exit 0
fi

"$HELPER_SCRIPT"
