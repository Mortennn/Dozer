/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa
import Preferences
import Defaults

extension Defaults.Keys {
    static let hideOnLogin: Defaults.Key<Bool> = Key<Bool>("hideOnLogin", default: false)
    static let hideAfterDelayEnabled: Defaults.Key<Bool> = Key<Bool>("hideAfterDelayEnabled", default: false)
    static let hideAfterDelay: Defaults.Key<TimeInterval> = Key<TimeInterval>("hideAfterDelay", default: 10)
    static let noIconMode: Defaults.Key<Bool> = Key<Bool>("noIconMode", default: false)
    static let removeDozerIconEnabled: Defaults.Key<Bool> = Key<Bool>("removeStatusIconEnabled", default: false)
    static let primaryDozerIcon: Defaults.Key<String> = Key<String>("primaryDozerIcon", default: "CircleStatusIcon")
    static let secondaryDozerIcon: Defaults.Key<String> = Key<String>("secondaryDozerIcon", default: "CircleStatusIcon")
    static let animationEnabled: Defaults.Key<Bool> = Key<Bool>("animationEnabeld", default: false)
}

struct UserDefaultKeys {
    struct Shortcuts {
        static let ToggleMenuItems: String = "toggleMenuItems"
    }
}

extension NSStoryboard.Name {
    static let preferences: NSStoryboard.Name = NSStoryboard.Name("Preferences")
}

extension PreferencePaneIdentifier {
    static let dozer = PreferencePaneIdentifier("dozer")
    static let general = PreferencePaneIdentifier("general")
}

struct AppInfo {
    static let bundleIdentifier: String = "com.mortennn.Dozer"
    static var releaseVersionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    static var buildVersionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
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
