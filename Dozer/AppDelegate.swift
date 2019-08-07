/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa
import Crashlytics
import Fabric
import MASShortcut
import Sparkle
import Defaults
import Preferences


final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        #if !DEBUG
            UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions": true])
            Fabric.with([Crashlytics.self])
        #endif

        MASShortcutBinder.shared()?.bindShortcut(withDefaultsKey: UserDefaultKeys.Shortcuts.ToggleMenuItems) { [unowned self] in
            DozerIcons.shared.toggle()
        }

        // Initalize Dozer Icons
        _ = DozerIcons.shared
    }

    // Show all Dozer icons when opening Dozer from Finder etc.
    func applicationOpenUntitledFile(_ sender: NSApplication) -> Bool {
        DozerIcons.shared.showAll()
        return true
    }

    lazy var preferences: [PreferencePane] = [
        Dozer(),
        General()
    ]

    lazy var preferencesWindowController = PreferencesWindowController(
        preferencePanes: preferences,
        style: .toolbarItems,
        animated: true,
        hidesToolbarForSingleItem: true
    )
}
