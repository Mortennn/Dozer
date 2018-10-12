//
//  AppDelegate.swift
//  Dozer
//
//  Created by Mortennn on 05/08/2018.
//  Copyright © 2018 Mortennn. All rights reserved.
//

import Cocoa
import MASShortcut

let DozerStatusItem1 = DozerStatusItem()
let DozerStatusItem2 = DozerStatusItem()
var DozerStatusItems:[DozerStatusItem] = [DozerStatusItem1, DozerStatusItem2]

class DozerStatusItem {
  
  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  
  let shownLength:CGFloat = 20
  let hiddenLength:CGFloat = 10000
  
  init() {
    statusItem.length = NSStatusItem.variableLength
    if let mainStatusItemButton = statusItem.button {
      mainStatusItemButton.target = self
      mainStatusItemButton.action = #selector(mainMenuItemClicked(sender:))
      mainStatusItemButton.image = Icons().shown
      mainStatusItemButton.sendAction(on: [.leftMouseDown, .rightMouseDown])
    }
  }
  
  func show() {
    statusItem.length = shownLength
  }
  
  func hidden() {
    statusItem.length = hiddenLength
  }
  
  @objc func mainMenuItemClicked(sender: AnyObject?) {
    guard let currentEvent = NSApp.currentEvent else {
      NSLog("read current event failed")
      return
    }
    if currentEvent.type == NSEvent.EventType.rightMouseDown {
//      MainStatusItemWindowController.shared.createWindows()
      statusItem.length = hiddenLength
    } else if currentEvent.type == NSEvent.EventType.leftMouseDown {
      let tmpView = NSView(frame: statusItem.button!.frame)
      statusItem.button!.addSubview(tmpView)
      let menu = createMenu(in: tmpView)
      statusItem.button!.menu = menu
    }
  }
  
  var isShown:Bool {
    get {
      return (statusItem.length == shownLength)
    }
  }
  
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  func applicationDidFinishLaunching(_ notification: Notification) {
    
    //firstRun()
    
    
    // TODO: fix shortcut
    // bind global shortcut
//    MASShortcutBinder.shared()?.bindShortcut(withDefaultsKey: UserDefaultKeys.Shortcuts.ToggleMenuItems, toAction: {
//      if mainStatusItem.isExpanded {
//        mainStatusItem.length = mainMenuItemLength
//        mainStatusItem.button!.image = Icons().shown
//        MainStatusItemWindowController.shared.removeWindows()
//      } else {
//        mainStatusItem.length = blockMenuItemLengthLarge
//        MainStatusItemWindowController.shared.createWindows()
//      }
//    })
    
    // listens for change is interface theme
    DistributedNotificationCenter.default.addObserver(
      self,
      selector: #selector(interfaceModeChanged(sender:)),
      name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"),
      object: nil)
    
    // listens for change in resolution
    NotificationCenter.default.addObserver(self,
      selector: #selector(screenDidChangeInResolution),
      name: NSApplication.didChangeScreenParametersNotification,
      object: nil)
  }
  // FIX: screen did change in resolution
    @objc func screenDidChangeInResolution() {
//      showStatusItems()
    }
  
  // FIX: handle interface mode changed
   @objc func interfaceModeChanged(sender: NSNotification) {
//    if mainStatusItem.isExpanded {
//      let _ = MainStatusItemWindowController.shared.windowInstances.map { $0.backgroundView.image = Icons().hidden }
//      showStatusItems() // FIXME: status items get showed, even when they shouldn't
//    } else {
//      mainStatusItem.button!.image = Icons().shown
//    }
  }
  
  @objc func showPreferences() {
    PreferencesController.shared.showPreferencesPane()
  }
  
}

func createMenu(in view:NSView) -> NSMenu {
  let newView = NSView(frame: view.frame)
  view.addSubview(newView)
  let menu = NSMenu()
  
  let about = NSMenuItem(title: "About", action: #selector(NSApp.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
  let preferences = NSMenuItem(title: "Preferences", action: #selector(AppDelegate.showPreferences), keyEquivalent: ",")
  let quit = NSMenuItem(title: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q")
  
  menu.addItem(about)
  menu.addItem(NSMenuItem.separator())
  menu.addItem(preferences)
  menu.addItem(NSMenuItem.separator())
  menu.addItem(quit)
  
  if isSystemAppearenceDark {
    newView.appearance = NSAppearance(named: .vibrantDark)
  } else {
    newView.appearance = NSAppearance(named: .vibrantLight)
  }

  menu.popUp(positioning: nil, at: NSPoint(x: 0, y: -5), in: newView)
  
  return menu
}


final class PreferencesController {
  private init() {}
  
  required internal init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static let shared = PreferencesController()
  private var preferencesController:NSWindowController?
  
  @objc func showPreferencesPane() {
    if preferencesController == nil {
      let storyboard = NSStoryboard(name: StoryboardNames.Preferences, bundle: nil)
      preferencesController = storyboard.instantiateInitialController() as? NSWindowController
    }
    
    if preferencesController != nil {
      preferencesController!.showWindow(nil)
      NSApp.activate(ignoringOtherApps: true)
    }
  }
}

//final class MainStatusItemWindowController {
//
//  private init() {}
//
//  static let shared = MainStatusItemWindowController()
//
//  var windowInstances:[MainStatusItemWindow] = []
//
//  public func createWindows() {
//    guard let statusItemBtnWindow = mainStatusItem.button?.window else {
//      fatalError("get status item button window failed for: \(mainStatusItem)")
//    }
//
//    // removes all existing window instances
//    removeWindows()
//    let pixelsToRight = statusItemBtnWindow.screen!.frame.width-(statusItemBtnWindow.frame.origin.x-statusItemBtnWindow.screen!.frame.origin.x)
//    for screen in NSScreen.screens {
//      let frame = NSRect(
//        x: screen.frame.width-pixelsToRight,
//        y: screen.frame.height-22,
//        width: mainMenuItemLength,
//        height: 22)
//      let windowInstance = MainStatusItemWindow(frame: frame, screen:screen)
//      windowInstances.append(windowInstance)
//      windowInstance.orderFront(nil)
//    }
//  }
//
//  public func removeWindows() {
//    let _ = windowInstances.map { $0.orderOut(nil) }
//    windowInstances = []
//  }
//}
//
//final class MainStatusItemWindow: NSPanel {
//
//  public var backgroundView:NSImageView!
//
//  convenience init(frame:NSRect, screen:NSScreen) {
//    self.init(contentRect:frame, styleMask: [.nonactivatingPanel], backing: .buffered, defer: false, screen: screen)
//    self.isOpaque = false
//    self.hasShadow = false
//    self.titlebarAppearsTransparent = true
//    self.titleVisibility = .hidden
//    self.level = NSWindow.Level(rawValue: (NSWindow.Level.statusBar.rawValue))
//    self.collectionBehavior = [.canJoinAllSpaces, .fullScreenNone]
//    self.backgroundColor = NSColor(white: 1, alpha: 0)
//    let backgroundImageView = NSImageView()
//    backgroundImageView.autoresizingMask = [.height, .width]
//    backgroundImageView.image = Icons().hidden
//    backgroundImageView.frame = self.contentView!.frame
//    backgroundView = backgroundImageView
//    self.contentView!.addSubview(backgroundImageView)
//    self.ignoresMouseEvents = false
//  }
//
//  override func mouseDown(with event: NSEvent) {
//    let menu = createMenu(in: self.contentView!)
//    self.menu = menu
//  }
//
//  override func rightMouseDown(with event: NSEvent) {
//    showStatusItems()
//  }
//
//}

// should be handled in the class itself
//extension NSStatusItem {
//  var isExpanded:Bool {
//    return (self.length == blockMenuItemLengthLarge)
//  }
//}

//func showStatusItems() {
//  mainStatusItem.length = mainMenuItemLength
//  for window in MainStatusItemWindowController.shared.windowInstances {
//    window.orderOut(nil)
//  }
//  MainStatusItemWindowController.shared.windowInstances = []
//  mainStatusItem.button!.image = Icons().shown
//}
