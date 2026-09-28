/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa
import Defaults

private struct StatusIconLength {
    static var show: CGFloat {
        Defaults[.buttonPadding]
    }
    static let hide: CGFloat = 10_000
}

class HelperstatusIcon {
    var type: StatusIconType

    let statusIcon: NSStatusItem = NSStatusBar.system.statusItem(withLength: StatusIconLength.show)

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
        NSStatusBar.system.removeStatusItem(statusIcon)
    }

    func show() {
        statusIcon.length = StatusIconLength.show
        if #available(macOS 27, *) {
            statusIcon.isVisible = true
        }
    }

    func hide() {
        if #available(macOS 27, *) {
            // Other applications are hidden by NativeMenuBarVisibility. Length
            // inflation only discards this item on the new menu bar.
            statusIcon.isVisible = false
            return
        }
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

    func setSize() {
        if statusIcon.length != StatusIconLength.hide {
            statusIcon.length = StatusIconLength.show
        }
        guard let statusIconButton = statusIcon.button else {
            fatalError("helper status item button failed")
        }
        let image = statusIconButton.image
        var size = DozerIcons.shared.iconFontSize
        if self.type == .remove {
            size /= 2
        }
        image?.size = NSSize(width: size, height: size)
        statusIconButton.image = image
    }

    func showRemoveIcons() {}

    @objc
    func statusIconClicked(_ sender: AnyObject?) {}

    var isShown: Bool {
        if #available(macOS 27, *) {
            return statusIcon.isVisible
        }
        return statusIcon.length == StatusIconLength.show
    }

    var isHidden: Bool {
        !isShown
    }

    var xPositionOnScreen: CGFloat {
        guard let dozerIconFrame = statusIcon.button?.window?.frame else {
            return 0
        }
        let dozerIconXPosition = dozerIconFrame.origin.x
        return dozerIconXPosition
    }
}
