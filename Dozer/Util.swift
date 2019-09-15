/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa

extension NSButton {
    var isChecked: Bool {
        get {
            return state == .on
        }
        set {
            state = newValue ? .on : .off
        }
    }
}

struct Icons {
    var helperstatusIcon: NSImage {
        return create(image: Assets.statusIconSingleLeft.name, 8, 8)
    }

    var removeStatusIcon: NSImage {
        return create(image: Assets.statusIconDoubleLeft.name, 8, 8)
    }

    private func create(image name: String, _ width: Int, _ height: Int) -> NSImage {
        guard let image = Bundle.main.image(forResource: NSImage.Name(name)) else {
            fatalError("get image failed")
        }
        image.size = NSSize(width: width, height: height)
        return image
    }
}
