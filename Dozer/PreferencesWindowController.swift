/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa

/// Minimal preferences window built programmatically — no XIBs, no
/// third-party preferences framework.
@MainActor
final class PreferencesWindowController: NSWindowController {
    private enum Defaults {
        static let hideAtLaunchKey = "hideAtLaunch"
    }

    private let launchAtLoginCheckbox = NSButton(checkboxWithTitle: "", target: nil, action: nil)
    private let hideAtLaunchCheckbox = NSButton(checkboxWithTitle: "", target: nil, action: nil)
    private let versionLabel = NSTextField(labelWithString: "")

    init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 360, height: 180),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Dozer"
        window.isReleasedWhenClosed = false
        window.center()
        super.init(window: window)
        buildUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is unavailable") }

    func show() {
        refresh()
        NSApp.activate(ignoringOtherApps: true)
        showWindow(nil)
        window?.makeKeyAndOrderFront(nil)
    }

    // MARK: - UI

    private func buildUI() {
        guard let contentView = window?.contentView else { return }

        launchAtLoginCheckbox.title = "Launch at login"
        launchAtLoginCheckbox.target = self
        launchAtLoginCheckbox.action = #selector(toggleLaunchAtLogin)

        hideAtLaunchCheckbox.title = "Hide menu bar icons at launch"
        hideAtLaunchCheckbox.target = self
        hideAtLaunchCheckbox.action = #selector(toggleHideAtLaunch)

        versionLabel.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
        versionLabel.textColor = .secondaryLabelColor

        let quitButton = NSButton(
            title: "Quit Dozer",
            target: NSApp,
            action: #selector(NSApplication.terminate(_:))
        )

        let stack = NSStackView(views: [
            launchAtLoginCheckbox,
            hideAtLaunchCheckbox,
            NSBox.separator(),
            quitButton,
            versionLabel
        ])
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func refresh() {
        launchAtLoginCheckbox.state = LaunchAtLogin.isEnabled ? .on : .off
        hideAtLaunchCheckbox.state = UserDefaults.standard.bool(forKey: Defaults.hideAtLaunchKey) ? .on : .off

        let info = Bundle.main.infoDictionary
        let short = info?["CFBundleShortVersionString"] as? String ?? "?"
        let build = info?["CFBundleVersion"] as? String ?? "?"
        versionLabel.stringValue = "Version \(short) (\(build))"
    }

    // MARK: - Actions

    @objc private func toggleLaunchAtLogin() {
        LaunchAtLogin.isEnabled = launchAtLoginCheckbox.state == .on
    }

    @objc private func toggleHideAtLaunch() {
        UserDefaults.standard.set(
            hideAtLaunchCheckbox.state == .on,
            forKey: Defaults.hideAtLaunchKey
        )
    }
}

private extension NSBox {
    static func separator() -> NSBox {
        let box = NSBox()
        box.boxType = .separator
        return box
    }
}
