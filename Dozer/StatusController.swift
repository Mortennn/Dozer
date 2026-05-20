/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa

/// Owns the two NSStatusItems that make Dozer work:
///
/// - `dot` is the only icon the user sees. It sits at the rightmost position
///   and handles clicks.
/// - `spacer` is invisible (1 px wide, no image). It is placed immediately to
///   the left of the dot. Expanding the spacer to a huge width pushes every
///   menu bar icon to its left off the screen, while the dot remains visible
///   and clickable.
@MainActor
final class StatusController {
    var onShowPreferences: (() -> Void)?

    private enum Constants {
        static let dotLength: CGFloat = 25
        static let dotImageSize: CGFloat = 10
        static let spacerVisible: CGFloat = 1
        static let spacerHidden: CGFloat = 10_000
        static let hideAtLaunchDelay: TimeInterval = 0.15
        static let hideAtLaunchKey = "hideAtLaunch"
    }

    private enum State {
        case shown
        case hidden
    }

    private let dot: NSStatusItem
    private let spacer: NSStatusItem
    private var state: State = .shown

    init() {
        // Order matters: the first NSStatusItem becomes the rightmost. The
        // spacer is appended after the dot so it lands immediately to the
        // left of it.
        dot = NSStatusBar.system.statusItem(withLength: Constants.dotLength)
        spacer = NSStatusBar.system.statusItem(withLength: Constants.spacerVisible)
        configureDot()
        configureSpacer()
    }

    func start() {
        if UserDefaults.standard.bool(forKey: Constants.hideAtLaunchKey) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.hideAtLaunchDelay) { [weak self] in
                self?.hide()
            }
        }
    }

    /// Force the menu bar icons back to a visible state.
    func show() {
        spacer.length = Constants.spacerVisible
        state = .shown
    }

    // MARK: - Private

    private func configureDot() {
        guard let button = dot.button else { return }
        let image = NSImage(named: "HelperStatusItemIcon")
        image?.isTemplate = true
        image?.size = NSSize(width: Constants.dotImageSize, height: Constants.dotImageSize)
        button.image = image
        button.target = self
        button.action = #selector(handleDotClick(_:))
        button.sendAction(on: [.leftMouseDown, .rightMouseDown])
    }

    private func configureSpacer() {
        spacer.button?.image = nil
    }

    @objc private func handleDotClick(_: Any?) {
        guard let event = NSApp.currentEvent else { return }
        switch event.type {
        case .leftMouseDown:
            toggle()
        case .rightMouseDown:
            onShowPreferences?()
        default:
            break
        }
    }

    private func toggle() {
        switch state {
        case .shown:
            hide()
        case .hidden:
            show()
        }
    }

    private func hide() {
        spacer.length = Constants.spacerHidden
        state = .hidden
    }
}
