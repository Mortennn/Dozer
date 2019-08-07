/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa
import Preferences
import MASShortcut
import LaunchAtLogin
import Sparkle
import Defaults

final class General: NSViewController, PreferencePane {
    let preferencePaneIdentifier = PreferencePaneIdentifier.general
    let preferencePaneTitle: String = "General"
    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!

    override var nibName: NSNib.Name? {
        return "General"
    }

    fileprivate var userShortCut: MASShortcut!

    @IBOutlet private var LaunchAtLoginCheckbox: NSButton!
    @IBOutlet private var CheckForUpdatesCheckbox: NSButton!
    @IBOutlet private var HideStatusBarIconsAfterDelayCheckbox: NSButton!
    @IBOutlet private var HideBothDozerIconsCheckbox: NSButton!
    @IBOutlet private var EnableRemoveDozerIconCheckbox: NSButton!
    @IBOutlet private var ToggleMenuItemsView: MASShortcutView!

    override func viewDidLoad() {
        super.viewDidLoad()

        LaunchAtLoginCheckbox.focusRingType = .none

        LaunchAtLoginCheckbox.isChecked = LaunchAtLogin.isEnabled
        if SUUpdater.shared() != nil {
            CheckForUpdatesCheckbox.isChecked = SUUpdater.shared()!.automaticallyChecksForUpdates
        } else {
            CheckForUpdatesCheckbox.isChecked = false
        }

        HideStatusBarIconsAfterDelayCheckbox.isChecked = defaults[.hideAfterDelayEnabled]
        HideBothDozerIconsCheckbox.isChecked = defaults[.noIconMode]
        EnableRemoveDozerIconCheckbox.isChecked = defaults[.removeDozerIconEnabled]

        ToggleMenuItemsView.associatedUserDefaultsKey = UserDefaultKeys.Shortcuts.ToggleMenuItems
        view.addSubview(ToggleMenuItemsView)

        ToggleMenuItemsView.shortcutValueChange = { _ -> Void in
            self.userShortCut = self.ToggleMenuItemsView.shortcutValue
        }
    }

    @IBAction private func launchAtLoginClicked(_ sender: NSButton) {
        LaunchAtLogin.isEnabled = (sender.state == .on)
    }

    @IBAction private func automaticallyCheckForUpdatesClicked(_ sender: NSButton) {
        guard SUUpdater.shared() != nil else {
            CheckForUpdatesCheckbox.isChecked = false
            return
        }
        SUUpdater.shared()!.automaticallyChecksForUpdates = CheckForUpdatesCheckbox.isChecked
    }

    @IBAction private func hideStatusBarIconsAfterDelayClicked(_ sender: NSButton) {
        DozerIcons.shared.hideStatusBarIconsAfterDelay = HideStatusBarIconsAfterDelayCheckbox.isChecked
    }

    @IBAction private func hideBothDozerIconsClicked(_ sender: NSButton) {
        DozerIcons.shared.hideBothDozerIcons = HideBothDozerIconsCheckbox.isChecked
    }

    @IBAction private func enableRemoveDozerIconClicked(_ sender: NSButton) {
        DozerIcons.shared.enableRemoveDozerIcon = EnableRemoveDozerIconCheckbox.isChecked
    }
}
