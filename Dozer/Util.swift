/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa
import Defaults

extension NSButton {
    var isChecked: Bool {
        get {
            state == .on
        }
        set {
            state = newValue ? .on : .off
        }
    }
}

struct Icons {
    var helperstatusIcon: NSImage {
        let size = Defaults[.iconSize]
        return create(image: "AppIcon", size, size)
    }

    var removeStatusIcon: NSImage {
        let size = Defaults[.iconSize] / 2
        return create(image: "AppIcon", size, size)
    }

    private func create(image name: String, _ width: Int, _ height: Int) -> NSImage {
        guard let image = Bundle.main.image(forResource: NSImage.Name(name)) else {
            fatalError("get image failed")
        }
        image.size = NSSize(width: width, height: height)
        return image
    }
}
