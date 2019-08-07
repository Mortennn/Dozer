/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa
import Defaults

public final class DozerIcons {
    static var shared = DozerIcons()
    private var dozerIcons: [HelperstatusIcon] = []
    private var timerToHideDozerIcons = Timer()
    private var dragState = DragState.off
    private let mouseEvents = EventMonitors()

    private init() {
        mouseEvents.add(.init(mask: [.leftMouseDown], handler: leftMouseDown))
        mouseEvents.add(.init(mask: [.leftMouseUp], handler: leftMouseUp))
        mouseEvents.start()

        dozerIcons.append(NormalStatusIcon())

        if !hideBothDozerIcons {
            dozerIcons.append(NormalStatusIcon())
        }

        if enableRemoveDozerIcon {
            dozerIcons.append(RemoveStatusIcon())
        }

        if hideStatusBarIconsAfterDelay {
            startTimer()
        }
    }

    // MARK: Observe changes to settings
    public var hideStatusBarIconsAfterDelay: Bool = defaults[.hideAfterDelayEnabled] {
        didSet {
            defaults[.hideAfterDelayEnabled] = self.hideStatusBarIconsAfterDelay
            if hideStatusBarIconsAfterDelay {
                startTimer()
            } else {
                stopTimer()
            }
        }
    }

    public var hideBothDozerIcons: Bool = defaults[.noIconMode] {
        didSet {
            defaults[.noIconMode] = self.hideBothDozerIcons
            if hideBothDozerIcons {
                let rightDozerIconXPos = get(dozerIcon: .normalRight).xPositionOnScreen
                dozerIcons.removeAll(where: { $0.xPositionOnScreen == rightDozerIconXPos })
            } else {
                dozerIcons.append(NormalStatusIcon())
            }
        }
    }

    public var enableRemoveDozerIcon: Bool = defaults[.removeDozerIconEnabled] {
        didSet {
            defaults[.removeDozerIconEnabled] = self.enableRemoveDozerIcon
            if enableRemoveDozerIcon {
                dozerIcons.append(RemoveStatusIcon())
            } else {
                dozerIcons.removeAll(where: { $0.type == .remove })
            }
            showAll()
        }
    }

    // MARK: Public methods
    public func hide() {
        perform(action: .hide, statusIcon: .remove)
        perform(action: .hide, statusIcon: .normalLeft)
        if defaults[.noIconMode] {
            perform(action: .hide, statusIcon: .normalRight)
        }
        didHideStatusBarIcons()
    }

    public func show() {
        perform(action: .hide, statusIcon: .remove)
        perform(action: .show, statusIcon: .normalLeft)
        if defaults[.noIconMode] {
            perform(action: .show, statusIcon: .normalRight)
        }
        didShowStatusBarIcons()
    }

    public func toggle() {
        if get(dozerIcon: .normalLeft).isShown {
            hide()
        } else {
            show()
        }
    }

    public func toggleRemove() {
        if get(dozerIcon: .remove).isShown {
            perform(action: .hide, statusIcon: .remove)
        } else {
            perform(action: .show, statusIcon: .remove)
        }
    }

    /// Force show all Dozer status bar icons
    public func showAll() {
        perform(action: .show, statusIcon: .remove)
        perform(action: .show, statusIcon: .normalLeft)
        perform(action: .show, statusIcon: .normalRight)
        didShowStatusBarIcons()
    }

    public func handleOptionClick() {
        if get(dozerIcon: .normalLeft).isShown {
            DozerIcons.shared.perform(
                action: .toggle,
                statusIcon: .remove
            )
        } else {
            DozerIcons.shared.perform(
                action: .show,
                statusIcon: .normalLeft
            )
            DozerIcons.shared.perform(
                action: .show,
                statusIcon: .remove
            )
        }
    }

    // MARK: Mouse events
    private func leftMouseDown(event: NSEvent) {
        guard
            event.modifierFlags.contains(.command) &&
                !event.modifierFlags.contains(.shift) &&
                !event.modifierFlags.contains(.option) else {
                    dragState = .off
                    return
        }

        dragState = .on

        DozerIcons.shared.show()
    }

    private func leftMouseUp(event: NSEvent) {
        if dragState == .on {
            DozerIcons.shared.show()
            resetTimer()
        }

        dragState = .off
    }

    // MARK: Show/hide lifecycle
    private func didShowStatusBarIcons() {
        startTimer()
        mouseEvents.start()
    }

    private func didHideStatusBarIcons() {
        stopTimer()
        mouseEvents.stop()
    }

    private func willHideStatusBarIcons() {
        guard defaults[.hideAfterDelayEnabled] else {
            return
        }
        // don't hide on user interaction with status bar
        guard !isUserInteractingWithStatusBar() else {
            resetTimer()
            return
        }

        // don't hide on drag events
        guard dragState == .off else {
            resetTimer()
            return
        }

        DozerIcons.shared.hide()
    }

    // MARK: timerToHideDozerIcons methods
    private func startTimer() {
        guard defaults[.hideAfterDelayEnabled] else {
            stopTimer()
            return
        }
        timerToHideDozerIcons = Timer.scheduledTimer(withTimeInterval: defaults[.hideAfterDelay], repeats: false) { (_: Timer) -> Void in
            self.willHideStatusBarIcons()
        }
    }

    private func stopTimer() {
        timerToHideDozerIcons.invalidate()
    }

    private func resetTimer() {
        self.stopTimer()
        self.startTimer()
    }

    // MARK: Private methods
    /// Will fail silently if statusIcon does not exist
    private func perform(action: StatusIconAction, statusIcon: DozerIcon) {
        if statusIcon == .remove {
            guard defaults[.removeDozerIconEnabled] else {
                return
            }
        }
        let theStatusIcon: HelperstatusIcon = get(dozerIcon: statusIcon)
        switch action {
        case .show:
            theStatusIcon.show()
        case .hide:
            theStatusIcon.hide()
        case .toggle:
            theStatusIcon.toggle()
        }
    }

    /// Will crash if trying to get ´DozerIcon´ which does not exist in the status bar
    private func get(dozerIcon: DozerIcon) -> HelperstatusIcon {
        var normalStatusIconsXPosition: [CGFloat] = []
        for statusIcon in dozerIcons where statusIcon.type == .normal {
            normalStatusIconsXPosition.append(statusIcon.xPositionOnScreen)
        }
        switch dozerIcon {
        case .remove:
            guard let removeStatusIcon = dozerIcons.first(where: { $0.type == .remove }) else {
                fatalError("Failed getting remove status icon")
            }
            return removeStatusIcon
        case .normalLeft:
            guard let leftStatusIcon = dozerIcons.first(where: { $0.xPositionOnScreen == normalStatusIconsXPosition.min() }) else {
                fatalError("Failed getting status icon on the left")
            }
            return leftStatusIcon
        case .normalRight:
            guard let rightStatusIcon = dozerIcons.first(where: { $0.xPositionOnScreen == normalStatusIconsXPosition.max() }) else {
                fatalError("Failed getting status icon on the right")
            }
            return rightStatusIcon
        }
    }

    /// Determines if the user is interacting with the status bar based on level, owner and y-coordinate
    ///
    /// - Returns: Returns whether the user is interacting with the status bar or not
    private func isUserInteractingWithStatusBar() -> Bool {
        let windowListType = CGWindowListOption.optionOnScreenOnly
        guard let windowInfoList = CGWindowListCopyWindowInfo(windowListType, kCGNullWindowID) as NSArray? as? [[String: AnyObject]] else {
            return false
        }
        var statusBarAppsWindowInfo: [Window] = []

        for windowInfo in windowInfoList {
            guard let window = Window(windowInfo) else { continue }
            if window.isStatusIcon {
                statusBarAppsWindowInfo.append(window)
            }
        }

        for windowInfo in windowInfoList {
            guard let window = Window(windowInfo) else { continue }
            guard window.isStatusIcon == false else { continue }

            for statusBarApp in statusBarAppsWindowInfo {
                guard statusBarApp.owner == window.owner else { continue }
                guard (statusBarApp.y + 22...statusBarApp.y + 30).contains(window.y) else { continue }

                return true
            }
        }

        return false
    }

    /// Wrapper class for CGWindowList
    private class Window {
        var x: Int = 0
        var y: Int = 0
        var width: Int = 0
        var height: Int = 0

        var level: Int
        var owner: String

        init?(_ windowInfo: [String: AnyObject]) {
            guard let level = windowInfo[kCGWindowLayer as String] as? Int else {
                return nil
            }
            guard let owner = windowInfo[kCGWindowOwnerName as String] as? String else {
                return nil
            }

            self.level = level
            self.owner = owner

            let bounds: [String: Int] = windowInfo[kCGWindowBounds as String] as! [String: Int]
            for item in bounds {
                switch item.key {
                case "X":
                    x = item.value
                case "Y":
                    y = item.value
                case "Width":
                    width = item.value
                case "Height":
                    height = item.value
                default:
                    continue
                }
            }
        }

        var isStatusIcon: Bool {
            guard level == 25 && height == 22 else {
                return false
            }
            return true
        }
    }
}
