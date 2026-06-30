/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa
import Settings
import KeyboardShortcuts
import LaunchAtLogin
import Sparkle
import Defaults

final class General: NSViewController, SettingsPane {
    let paneIdentifier = Settings.PaneIdentifier.general
    let paneTitle: String = "General"
    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!

    override var nibName: NSNib.Name? { "General" }

    private var updater: SPUUpdater? {
        (NSApp.delegate as? AppDelegate)?.updaterController.updater
    }

    @IBOutlet private var LaunchAtLoginCheckbox: NSButton!
    @IBOutlet private var CheckForUpdatesCheckbox: NSButton!
    @IBOutlet private var HideStatusBarIconsAtLaunchCheckbox: NSButton!
    @IBOutlet private var HideStatusBarIconsAfterDelayCheckbox: NSButton!
    @IBOutlet private var HideStatusBarIconsSecondsPopUpButton: NSPopUpButton!
    @IBOutlet private var HideBothDozerIconsCheckbox: NSButton!
    @IBOutlet private var EnableRemoveDozerIconCheckbox: NSButton!
    @IBOutlet private var ShowIconAndMenuCheckbox: NSButton!
    @IBOutlet private var FontSizePopUpButton: NSPopUpButton!
    @IBOutlet private var ButtonPaddingPopUpButton: NSPopUpButton!
    @IBOutlet private var ToggleMenuItemsView: NSView!

    override func viewDidLoad() {
        super.viewDidLoad()

        LaunchAtLoginCheckbox.focusRingType = .none

        LaunchAtLoginCheckbox.isChecked = LaunchAtLogin.isEnabled
        if let updater = updater {
            CheckForUpdatesCheckbox.isChecked = updater.automaticallyChecksForUpdates
        } else {
            CheckForUpdatesCheckbox.isChecked = false
        }

        HideStatusBarIconsAtLaunchCheckbox.isChecked = Defaults[.hideAtLaunchEnabled]
        HideStatusBarIconsAfterDelayCheckbox.isChecked = Defaults[.hideAfterDelayEnabled]
        HideBothDozerIconsCheckbox.isChecked = Defaults[.noIconMode]
        EnableRemoveDozerIconCheckbox.isChecked = Defaults[.removeDozerIconEnabled]
        ShowIconAndMenuCheckbox.isChecked = Defaults[.showIconAndMenuEnabled]
        HideStatusBarIconsSecondsPopUpButton.selectItem(withTitle: "\(Int(Defaults[.hideAfterDelay])) seconds")
        FontSizePopUpButton.selectItem(withTitle: "\(Int(Defaults[.iconSize])) px")
        ButtonPaddingPopUpButton.selectItem(withTitle: "\(Int(Defaults[.buttonPadding])) px")

        // Host the KeyboardShortcuts recorder inside the container view from the XIB.
        // RecorderCocoa cannot be loaded from a nib, so it is created programmatically.
        let recorder = KeyboardShortcuts.RecorderCocoa(for: .toggleMenuItems) { [weak self] _ in
            self?.configureEnabledNoIconCheckbox()
        }
        recorder.frame = ToggleMenuItemsView.bounds
        recorder.autoresizingMask = [.width, .height]
        ToggleMenuItemsView.addSubview(recorder)
        configureEnabledNoIconCheckbox()
    }

    @IBAction private func launchAtLoginClicked(_ sender: NSButton) {
        LaunchAtLogin.isEnabled = (sender.state == .on)
    }

    @IBAction private func automaticallyCheckForUpdatesClicked(_ sender: NSButton) {
        guard let updater = updater else {
            CheckForUpdatesCheckbox.isChecked = false
            return
        }
        updater.automaticallyChecksForUpdates = CheckForUpdatesCheckbox.isChecked
    }

    @IBAction private func hideStatusBarIconsAtLaunchClicked(_ sender: NSButton) {
        DozerIcons.shared.hideStatusBarIconsAtLaunch = HideStatusBarIconsAtLaunchCheckbox.isChecked
    }

    @IBAction private func hideStatusBarIconsAfterDelayClicked(_ sender: NSButton) {
        DozerIcons.shared.hideStatusBarIconsAfterDelay = HideStatusBarIconsAfterDelayCheckbox.isChecked
    }

    @IBAction private func hideStatusBarIconsSecondsUpdated(_ sender: NSPopUpButton) {
        Defaults[.hideAfterDelay] = TimeInterval(HideStatusBarIconsSecondsPopUpButton.selectedTag())
        DozerIcons.shared.resetTimer()
    }

    @IBAction private func hideBothDozerIconsClicked(_ sender: NSButton) {
        DozerIcons.shared.hideBothDozerIcons = HideBothDozerIconsCheckbox.isChecked
    }

    @IBAction private func showIconAndMenuClicked(_ sender: NSButton) {
        DozerIcons.shared.enableIconAndMenu = ShowIconAndMenuCheckbox.isChecked
    }

    @IBAction private func fontSizeChanged(_ sender: NSPopUpButton) {
        DozerIcons.shared.iconFontSize = FontSizePopUpButton.selectedTag()
    }

    @IBAction private func buttonPaddingChanged(_ sender: NSPopUpButton) {
        DozerIcons.shared.buttonPadding = CGFloat(ButtonPaddingPopUpButton.selectedTag())
    }

    @IBAction private func enableRemoveDozerIconClicked(_ sender: NSButton) {
        DozerIcons.shared.enableRemoveDozerIcon = EnableRemoveDozerIconCheckbox.isChecked
    }

    /// disables the noIcon-checkbox if no shortcut is set and keeps track whether shortcut is set
    private func configureEnabledNoIconCheckbox() {
        if KeyboardShortcuts.getShortcut(for: .toggleMenuItems) == nil {
            HideBothDozerIconsCheckbox.isEnabled = false
            Defaults[.isShortcutSet] = false
        } else {
            HideBothDozerIconsCheckbox.isEnabled = true
            Defaults[.isShortcutSet] = true
        }
    }
}
