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
	<a href="https://img.shields.io/badge/requirements-macOS Ventura+-ff69b4.svg">
 		<img src="https://img.shields.io/badge/requirements-macOS Ventura+-lightgrey.svg" alt="systemrequirements">
	</a>
	<a href="https://opensource.org/licenses/MPL-2.0">
 		<img src="https://img.shields.io/badge/License-MPL%202.0-orange.svg" alt="license">
	</a>
</p>

## ⚙️ Install

[Download](https://github.com/Mortennn/Dozer/releases/latest), open and drag the app to the Applications folder.

## ⚫️ How it works

Dozer adds **one** small dot to your menu bar. Click it to hide every menu bar icon to its left; click it again to bring them back.

Under the hood Dozer keeps two `NSStatusItem`s in the menu bar:

* a visible dot (the only one you ever see), which handles the click;
* an invisible 1 px spacer placed immediately to its left, which expands to ~10 000 px when you click hide, pushing every menu bar icon to its left off the screen. The dot itself sits to the right of the spacer, so it stays put and remains clickable.

## 👨‍💻 Usage

* Drag the menu bar icons you want to hide to the left of the Dozer dot (hold `⌘` while dragging).
* Left-click the dot to hide / show those icons.
* Right-click the dot to open the preferences window.

## 🪶 Footprint

Dozer is intentionally tiny: a single application target, no Carthage, only Sparkle (auto-updates) as an SPM dependency, no background polling timers. The app sits idle in the menu bar between clicks.

## 🛠️ Build

```shell
brew install xcodegen
make build
```

## 📄 Requirements

macOS 13 Ventura or later. Universal binary (Apple Silicon + Intel).
