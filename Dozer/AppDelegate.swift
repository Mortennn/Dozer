/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa
import Sparkle

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusController = StatusController()
    private let updaterController = SPUStandardUpdaterController(
        startingUpdater: true,
        updaterDelegate: nil,
        userDriverDelegate: nil
    )
    private lazy var preferencesWindowController = PreferencesWindowController(
        updater: updaterController.updater
    )

    func applicationDidFinishLaunching(_: Notification) {
        NSApp.setActivationPolicy(.accessory)

        statusController.onShowPreferences = { [weak self] in
            self?.preferencesWindowController.show()
        }
        statusController.start()
    }

    func applicationOpenUntitledFile(_: NSApplication) -> Bool {
        statusController.show()
        preferencesWindowController.show()
        return true
    }
}
