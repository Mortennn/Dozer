// This can be used when detecting clicks on status bar
extension NSEvent {
    var clickedWindowInfo: [String: AnyObject]? {
        let type = CGWindowListOption.optionOnScreenOnly
        let windowList = CGWindowListCopyWindowInfo(type, kCGNullWindowID) as NSArray? as? [[String: AnyObject]]

        for entry in windowList! {
            guard let windowNumber = entry[kCGWindowNumber as String] as? Int else { continue }
            if windowNumber == self.windowNumber {
                return entry
            }
        }
        return nil
    }
}
