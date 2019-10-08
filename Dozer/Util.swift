/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa
import Defaults

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
        return selectIconImage(iconName: IconList.list[defaults[.primaryDozerIcon]])
    }

    var removeStatusIcon: NSImage {
        return selectIconImage(iconName: IconList.list[defaults[.secondaryDozerIcon]])
    }

    func selectIconImage(iconName: String) -> NSImage {
        switch iconName {
        case "SingleLeftStatusIcon":
            return create(image: iconName, 8, 8)
        case "DoubleLeftStatusIcon":
            return create(image: iconName, 8, 8)
        case "SingleRightStatusIcon":
            return create(image: iconName, 8, 8)
        case "DoubleRightStatusIcon":
            return create(image: iconName, 8, 8)
        case "BigCircleStatusIcon":
            return create(image: Assets.circleStatusIcon.name, 12, 12)
        default:
            return create(image: Assets.circleStatusIcon.name, 8, 8)
        }
    }

    private func create(image name: String, _ width: Int, _ height: Int) -> NSImage {
        guard let image = Bundle.main.image(forResource: NSImage.Name(name)) else {
            fatalError("get image failed")
        }
        image.size = NSSize(width: width, height: height)
        return image
    }
}
