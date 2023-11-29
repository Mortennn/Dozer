/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa
import Settings
import Defaults
import KeyboardShortcuts

extension Defaults.Keys {
    static let hideOnLogin: Defaults.Key<Bool> = Key<Bool>("hideOnLogin", default: false)
    static let hideAtLaunchEnabled: Defaults.Key<Bool> = Key<Bool>("hideAtLaunchEnabled", default: false)
    static let hideAfterDelayEnabled: Defaults.Key<Bool> = Key<Bool>("hideAfterDelayEnabled", default: false)
    static let hideAfterDelay: Defaults.Key<TimeInterval> = Key<TimeInterval>("hideAfterDelay", default: 10)
    static let noIconMode: Defaults.Key<Bool> = Key<Bool>("noIconMode", default: false)
    static let removeDozerIconEnabled: Defaults.Key<Bool> = Key<Bool>("removeStatusIconEnabled", default: false)
    static let showIconAndMenuEnabled: Defaults.Key<Bool> = Key<Bool>("showIconAndMenuEnabled", default: false)
    static let iconSize: Defaults.Key<Int> = Key<Int>("fontSize", default: 10)
    static let buttonPadding: Defaults.Key<CGFloat> = Key<CGFloat>("buttonPadding", default: 25)
    static let animationEnabled: Defaults.Key<Bool> = Key<Bool>("animationEnabeld", default: false)
    static let isShortcutSet: Defaults.Key<Bool> = Key<Bool>("isShortcutSet", default: false)
}

extension KeyboardShortcuts.Name {
    static let ToggleMenuItems = Self("toggleMenuItems")
}

extension NSStoryboard.Name {
    static let preferences: NSStoryboard.Name = NSStoryboard.Name("Preferences")
}

extension Settings.PaneIdentifier {
    static let dozer = Self("dozer")
    static let general = Self("general")
}

struct AppInfo {
    static let bundleIdentifier: String = Bundle.main.bundleIdentifier!
    static var releaseVersionNumber: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    static var buildVersionNumber: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
}

enum StatusIconAction {
    case show
    case hide
    case toggle
}

enum StatusIconType {
    case normal
    case remove
}

enum DozerIcon {
    case remove
    case normalLeft
    case normalRight
}
