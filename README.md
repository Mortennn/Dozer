<p align="center">
	<img width="200" height="200" margin-right="100%" src="https://raw.githubusercontent.com/Mortennn/Dozer/master/Stuff/AppIcon.png">
</p>
<p align="center">Hide menu bar icons to give your Mac a cleaner look.</p>
<p align="center">
	<a href="https://github.com/Mortennn/Dozer/releases/latest">
 		<img src="https://img.shields.io/badge/download-latest-brightgreen.svg" alt="download">
	<a href="https://img.shields.io/badge/platform-macOS-lightgrey.svg">
 		<img src="https://img.shields.io/badge/platform-macOS-lightgrey.svg" alt="platform">
	</a>
	<a href="https://img.shields.io/badge/requirements-macOS High Sierra+-ff69b4.svg">
 		<img src="https://img.shields.io/badge/requirements-macOS High Sierra+-lightgrey.svg" alt="systemrequirements">
	</a>
	<a href="https://github.com/sindresorhus/swiftlint-sindre">
 		<img src="https://img.shields.io/badge/SwiftLint-Sindre-hotpink.svg" alt="swiftlint">
	</a>
	<a href="https://opensource.org/licenses/MPL-2.0">
 		<img src="https://img.shields.io/badge/License-MPL%202.0-orange.svg" alt="license">
	</a>
</p>
<p align="center">
	<img height="100" min-width="100" src="https://github.com/Mortennn/Dozer/raw/master/Stuff/demo.gif" alt="demo">
</p>

<p align="center"></p>
<a href="https://www.buymeacoffee.com/mortennn" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

## ⚙️ Install
Using [Homebrew Cask](https://formulae.brew.sh/cask/dozer):
```shell
brew install --cask dozer
```

Manual:

[Download](https://github.com/Mortennn/Dozer/releases/latest), open and drag the app to the Applications folder.

## ⚫️ Dozer Icons

There are 2 or 3, numbered from right to left:

1. this can be positioned anywhere you prefer, it is only a point of interaction
2. this and everything to its left will be hidden/shown by clicking any Dozer icon
3. (Optional) the "remove" icon and everything to its left will be hidden/shown by option-clicking any Dozer icon

## 👨‍💻 Usage

* Move the icons you want to hide until clicked to the left of the second Dozer icon
* Move the icons you want to hide until option-clicked to the left of the third Dozer icon

**N.B. hold command (`⌘`) then drag to move the menu bar icons.**

## 👇 Interactions
* Left-click one of the Dozer icons to hide/show the first group of menu bar icons
* Option-Left-click one of the Dozer icons to show the second group of menu bar icons (optional)
* Right-click one of the Dozer icons to open the settings

<!-- GIF is commented out until it is redone -->
<!-- **Checkout [this GIF](https://raw.githubusercontent.com/Mortennn/Dozer/master/Stuff/demo.gif) to watch Dozer in action.** -->

## 📄 Requirements
macOS 10.13+

## macOS 27 fork

The `macOS-27` branch adds an experimental compatibility path for macOS 27.
Apple's new menu bar discards Dozer's oversized separator instead of hiding
the icons to its left. This branch uses the system's menu bar visibility service
on macOS 27, and retains the original mechanism on earlier releases.

Build a local Apple Silicon + Intel app with Xcode and Homebrew installed:

```shell
brew install carthage xcodegen swiftgen swiftlint
make app
```

The app is at `build/Build/Products/Release/Dozer.app`. Quit the previous Dozer,
copy this build to `/Applications/Dozer.app`, and launch it from there.
On the first hide, allow Dozer in **System Settings → Privacy & Security →
Accessibility**, then click the dot again. Arrange the icons with ⌘-drag as
described above; the left Dozer dot remains the normal hiding boundary.

macOS 27 limitations:

- Visibility is controlled per application. If an app has icons on both sides
  of a separator, its most visible placement wins and its icons stay together.
- macOS keeps core system controls, including Control Center, Wi-Fi and the clock, visible.
- This uses the private `MenuBarClientCore` framework, following
  [Hidden Bar's macOS 27 implementation](https://github.com/dwarvesf/hidden/releases/tag/v1.11.1).
  An OS update may change it. If it is unavailable or a request fails, Dozer
  restores the icons and explains the problem.
- Place the app in `/Applications` before using it. The system must resolve
  Dozer's bundle identifier to keep its toggle visible.
- This locally signed build is intended for personal use. A distributed release
  still needs Developer ID signing and notarization. Rebuilding may require
  granting Accessibility again.
- Layout is read while all sections are visible. After rearranging icons with
  the optional remove section active, Option-click to show all sections before
  collapsing again. Apps launched while collapsed may appear after the next expand.

Run `make test` after the initial build to check classification, cancellation,
permission errors, and restoration. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)
for the license of the adapted visibility bridge and Accessibility inventory.
