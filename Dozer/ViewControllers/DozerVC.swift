/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa
import Sparkle
import Preferences

final class Dozer: NSViewController, PreferencePane {
    let preferencePaneIdentifier = PreferencePaneIdentifier.dozer
    let preferencePaneTitle: String = "Dozer"
    let toolbarItemIcon = NSImage(named: "AppIcon")!

    override var nibName: NSNib.Name? { "Dozer" }

    @IBOutlet private var versionLabel: NSTextField!
    @IBOutlet private var checkForUpdates: NSButton!
    @IBOutlet private var quit: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let releaseVersionNumber = AppInfo.releaseVersionNumber,
            let buildVersionNumber = AppInfo.buildVersionNumber {
            versionLabel.stringValue = "\(releaseVersionNumber) (\(buildVersionNumber))"
        }

        checkForUpdates.target = SUUpdater.shared()!
        checkForUpdates.action = #selector(SUUpdater.shared()!.checkForUpdates(_:))

        quit.action = #selector(NSApp.terminate(_:))
    }
}
