import Cocoa

extension NSScreen {
    /// Takes a window point an outputs the screen the window is located on
    ///
    /// - Parameter point: Window point
    /// - Returns: The screen the window is located on
    class func currentScreenForPointLocation(point: NSPoint) -> NSScreen? {
        for screen in NSScreen.screens {
            if NSMouseInRect(point, screen.frame, false) {
                return screen
            }
        }
        return nil
    }

    /// Converts global point to point relative to screen
    ///
    /// - Parameter aPoint: window point
    /// - Returns: window point relative to screen
    func convertPoint(toScreenCoordinates aPoint: NSPoint) -> NSPoint {
        let normalizedX: CGFloat = abs(abs(frame.origin.x) - abs(aPoint.x))
        let normalizedY: CGFloat = aPoint.y - frame.origin.y

        return NSPoint(x: normalizedX, y: normalizedY)
    }

    func flip(_ aPoint: NSPoint) -> NSPoint {
        return NSPoint(x: aPoint.x, y: frame.size.height - aPoint.y)
    }
}

// ORIGINAL
// extension NSScreen {
//    class func currentScreenForMouseLocation() -> NSScreen? {
//        let mouseLocation: NSPoint = NSEvent.mouseLocation
//
//        let screenEnumerator: NSEnumerator = (NSScreen.screens as NSArray).objectEnumerator()
//        var screen: NSScreen?
//        while (screen = screenEnumerator.nextObject() as? NSScreen) != nil, !NSMouseInRect(mouseLocation, screen!.frame, false) {}
//
//        return screen
//    }
//
//    func convertPoint(toScreenCoordinates aPoint: NSPoint) -> NSPoint {
//        let normalizedX: CGFloat = abs(abs(frame.origin.x) - abs(aPoint.x))
//        let normalizedY: CGFloat = aPoint.y - frame.origin.y
//
//        return NSPoint(x: normalizedX, y: normalizedY)
//    }
//
//    func flip(_ aPoint: NSPoint) -> NSPoint {
//        return NSPoint(x: aPoint.x, y: frame.size.height - aPoint.y)
//    }
// }
