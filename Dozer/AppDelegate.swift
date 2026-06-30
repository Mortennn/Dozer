/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa
import KeyboardShortcuts
import Sparkle
import Defaults
import Settings


final class AppDelegate: NSObject, NSApplicationDelegate {
    // Sparkle 2 updater. Shared so the settings panes can read/write its state.
    let updaterController = SPUStandardUpdaterController(
        startingUpdater: true,
        updaterDelegate: nil,
        userDriverDelegate: nil
    )

    func applicationDidFinishLaunching(_: Notification) {
        // Carry over a shortcut saved by the old MASShortcut integration.
        migrateLegacyShortcutIfNeeded()

        // Trigger on key-down to match MASShortcut's original behavior.
        KeyboardShortcuts.onKeyDown(for: .toggleMenuItems) {
            DozerIcons.shared.toggle()
        }

        // Initalize Dozer Icons
        _ = DozerIcons.shared

        // If enabled hide menu bar icons at launch
        DozerIcons.shared.hideAtLaunch()

        _ = DozerIcons.toggleDockIcon(showIcon: false)
    }

    // Show all Dozer icons when opening Dozer from Finder etc.
    func applicationOpenUntitledFile(_ sender: NSApplication) -> Bool {
        DozerIcons.shared.showAll()
        return true
    }

    /// Import a shortcut saved by the previous MASShortcut integration so
    /// existing users keep their toggle hotkey after upgrading.
    ///
    /// MASShortcut (via `MASShortcutBinder`) stored the shortcut under the
    /// `"toggleMenuItems"` UserDefaults key as a `{keyCode, modifierFlags}`
    /// dictionary, where `modifierFlags` are Cocoa `NSEvent.ModifierFlags`.
    /// KeyboardShortcuts uses its own `"KeyboardShortcuts_"`-prefixed storage,
    /// so without this the saved shortcut would silently disappear.
    @MainActor
    private func migrateLegacyShortcutIfNeeded() {
        let legacyKey = "toggleMenuItems"
        let defaults = UserDefaults.standard

        guard let legacy = defaults.dictionary(forKey: legacyKey) else {
            return
        }

        // Only import if the user has not already recorded one with the new API.
        if KeyboardShortcuts.getShortcut(for: .toggleMenuItems) == nil,
            let keyCode = (legacy["keyCode"] as? NSNumber)?.intValue,
            let modifierFlags = (legacy["modifierFlags"] as? NSNumber)?.uintValue {
            let shortcut = KeyboardShortcuts.Shortcut(
                KeyboardShortcuts.Key(rawValue: keyCode),
                modifiers: NSEvent.ModifierFlags(rawValue: modifierFlags)
            )
            KeyboardShortcuts.setShortcut(shortcut, for: .toggleMenuItems)
            Defaults[.isShortcutSet] = true
        }

        // Drop the obsolete key so this only runs once.
        defaults.removeObject(forKey: legacyKey)
    }

    lazy var preferences: [SettingsPane] = [
        Dozer(),
        General()
    ]

    lazy var preferencesWindowController = SettingsWindowController(
        panes: preferences,
        style: .toolbarItems,
        animated: true,
        hidesToolbarForSingleItem: true
    )

    /// Open the settings window, reliably in front of other apps.
    ///
    /// The Settings library relies on the cooperative `NSApp.activate()` on
    /// macOS 14+, which does not reliably bring an accessory (menu-bar) app's
    /// window forward, so the window can open behind the frontmost app.
    /// `orderFrontRegardless()` forces it above other apps' windows.
    func showPreferences() {
        preferencesWindowController.show(pane: .general)
        preferencesWindowController.window?.orderFrontRegardless()
    }
}
