// Generated using SwiftGen-compatible output for the current asset catalog.
// This file is checked in so Dozer can build when SwiftGen is unavailable.

import AppKit

internal enum Assets {
    internal static let appIcon = ImageAsset(name: "AppIcon")
    internal static let helperStatusItemIcon = ImageAsset(name: "HelperStatusItemIcon")
}

internal struct ImageAsset {
    internal fileprivate(set) var name: String

    internal var image: NSImage {
        let bundle = BundleToken.bundle
        guard let result = bundle.image(forResource: NSImage.Name(name)) else {
            fatalError("Unable to load image asset named \(name).")
        }
        return result
    }
}

private final class BundleToken {
    static let bundle = Bundle(for: BundleToken.self)
}
