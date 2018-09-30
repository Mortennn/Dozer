//
//  StatusItem.swift
//  Dozer
//
//  Created by Mortennn on 11/08/2018.
//

//import Cocoa
//
//final class StatusItem {
//
//    static let shared = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
//    fileprivate static var registeredScreenPositionX:CGFloat!
//
//    public func constructStatusItem() {
//        // Contructs the status item
//        if let button = StatusItem.shared.button {
//            button.image = NSImage(named: menuBarIconFilled)
//            button.image?.isTemplate = true
//            let appDel = NSApp.delegate as! AppDelegate
//            button.target = appDel
//            button.action =  #selector(appDel.statusItemClicked) // located in appdelegate
//            button.sendAction(on: [.leftMouseDown, .rightMouseDown])
//
//        }
//        StatusItem.shared.highlightMode = false
//        StatusItem.registeredScreenPositionX = StatusItem.shared.button!.window!.frame.origin.x
//        StatusItem.shared.button?.window?.level = NSWindow.Level(rawValue: 27) // overlayWindows are 26
//    }
//
//    public func showPopUpMenu() {
//        let appDel = NSApp.delegate! as! AppDelegate
//
//        let menu = NSMenu()
//        menu.addItem(NSMenuItem(title: "About", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: ""))
//        menu.addItem(NSMenuItem.separator())
//        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(appDel.showPreferences), keyEquivalent: ","))
//        menu.addItem(NSMenuItem.separator())
//        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
//        StatusItem.shared.popUpMenu(menu)
//    }
//
//    public func screenPositionHasChanged() -> Bool {
//        let registeredScreenPositionX = StatusItem.registeredScreenPositionX
//        let screenPositionX = StatusItem.shared.button!.window!.frame.origin.x
//        let screenPositionHasChanged = (registeredScreenPositionX != screenPositionX)
//        StatusItem.registeredScreenPositionX = screenPositionX
//        return screenPositionHasChanged
//    }
//
//}
