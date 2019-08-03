/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa
import Defaults

private struct StatusIconLength {
    static let show: CGFloat = 25
    static let hide: CGFloat = 10_000
}

class HelperstatusIcon {
    var type: StatusIconType

    let statusIcon: NSStatusItem = NSStatusBar.system.statusItem(withLength: 25)

    init() {
        type = .normal
        statusIcon.length = StatusIconLength.show
        statusIcon.highlightMode = false

        guard let statusIconButton = statusIcon.button else {
            fatalError("helper status item button failed")
        }

        statusIconButton.target = self
        statusIconButton.action = #selector(statusIconClicked(_:))
        setIcon()
        statusIconButton.sendAction(on: [.leftMouseDown, .rightMouseDown])
    }

    deinit {
        print("status item has been deallocated")
    }

    func show() {
        statusIcon.length = StatusIconLength.show
    }

    func hide() {
        statusIcon.length = StatusIconLength.hide
    }

    func toggle() {
        if isShown {
            hide()
        } else {
            show()
        }
    }

    func setIcon() {
        guard let statusIconButton = statusIcon.button else {
            fatalError("helper status item button failed")
        }
        statusIconButton.image = Icons().helperstatusIcon
        statusIconButton.image!.isTemplate = true
    }

    func showRemoveIcons() {}

    @objc func statusIconClicked(_ sender: AnyObject?) {}

    var isShown: Bool {
        return (statusIcon.length == StatusIconLength.show)
    }

    var isHidden: Bool {
        return (statusIcon.length == StatusIconLength.hide)
    }

    var xPositionOnScreen: CGFloat {
        guard let dozerIconFrame = statusIcon.button?.window?.frame else {
            return 0
        }
        let dozerIconXPosition = dozerIconFrame.origin.x
        return dozerIconXPosition
    }
}
