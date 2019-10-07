/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa
import Defaults

class RemoveStatusIcon: HelperstatusIcon {
    override init() {
        super.init()
        type = .remove
    }

    override func statusIconClicked(_: AnyObject?) {
        guard let currentEvent = NSApp.currentEvent else {
            return
        }

        switch currentEvent.type {
        case .leftMouseDown:
            DozerIcons.shared.toggleRemove()
        case .rightMouseDown:
            appDelegate.preferencesWindowController.show(preferencePane: .general)
        default:
            break
        }
    }

    override func setIcon(imageIndex: Int) {
        guard let statusIconButton = statusIcon.button else {
            fatalError("helper status item button failed")
        }
        statusIconButton.image = Icons().removeStatusIcon
        statusIconButton.image!.isTemplate = true
    }
}
