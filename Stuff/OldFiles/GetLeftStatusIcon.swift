import Cocoa

#warning("possible bug: this should only return the visible icons positions")
func getLeftStatusIcon() -> Int {
    guard let windowInfoList = CGWindowListCopyWindowInfo(CGWindowListOption.optionOnScreenOnly, kCGNullWindowID) as NSArray? as? [[String: AnyObject]] else {
        print("Failed getting the left status icon")
        return 0
    }

    var statusBarIconX: [Int] = []

    // collect all status bar icons x positions
    for windowInfo in windowInfoList {
        guard let window = Window(windowInfo) else { continue }
        guard window.isStatusIcon else { continue }
        statusBarIconX.append(window.x)
    }

    // find the smallest x position
    guard let minX = statusBarIconX.min() else {
        print("Failed getting the smallest x position")
        return 0
    }
    return minX
}
