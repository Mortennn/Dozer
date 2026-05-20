# Changelog

## Version 5.0.0
Full rewrite focused on a smaller footprint.

Breaking:
* Minimum macOS bumped to **13 Ventura**.
* Carthage is no longer used. The only third-party dependency is Sparkle, fetched via Swift Package Manager.
* Removed features: global hotkey, auto-hide after delay, the optional "remove" icon (option-click second group), dock icon toggle ("Show icon and menu"), icon size / button padding settings, "no icon" mode.

New:
* Universal binary (`arm64` + `x86_64`) — runs natively on Apple Silicon.
* Single Dozer dot. Clicking it hides every menu bar icon to its left and clicking again restores them. The dot itself is always visible.
* Programmatic preferences window: launch at login, hide at launch, automatic updates.
* `LaunchAtLogin` now uses `SMAppService` (built into macOS 13+) instead of an external dependency.

Internal:
* Dropped Carthage, SwiftGen, SwiftLint, the bridging header, all XIBs and the multi-icon orchestration code.
* The status bar logic now lives in a single `StatusController` (~100 lines).

## Version 4.2.0
New features:
* Configure amount of seconds to hide the icons after #104. @blakedgordon
* Resize icons and padding capability added #101. @blakedgordon

Fixed:
* Fix both dozer icons from being hidden #105. @blakedgordon

Thank you @blakedgordon for the contributions🙌

## Version 4.1.0
New features:
* Hide status bar icons at launch #78. @aonez

Fixed:
* Reduce CPU usage when "Hide status bar icons after 10 seconds" is checked #78. @aonez

Thank you @aonez for the contributions🙌

## Version 4
New features:
* ”Remove”-icon. Additional icon to hide/show icons with `option+click`
* Auto-hide status bar icons #22
* ”No Icon”-mode. Hide/show only using keyboard shortcut

Other:
* Improved UI in preferences
