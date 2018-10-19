//
//  AppDelegate.swift
//  Dozer
//
//  Created by Mortennn on 05/08/2018.
//  Copyright © 2018 Mortennn. All rights reserved.
//

import Cocoa
import MASShortcut

let dozerStatusItem = DozerStatusItem()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  func applicationDidFinishLaunching(_ notification: Notification) {
    
    handleMouseMoved()
    
    #warning("first run is not enabled")
    //firstRun()

    #warning("FIX: fix shortcut")
    // bind global shortcut
    MASShortcutBinder.shared()?.bindShortcut(withDefaultsKey: UserDefaultKeys.Shortcuts.ToggleMenuItems, toAction: {
    
    })
    
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
  
  #warning("FIX: screen did change in resolution")
    @objc func screenDidChangeInResolution() {
//      showStatusItems()
    }
  
  #warning("FIX: handle interface mode changed")
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

final class PreferencesController {
  private init() {}
  
  required internal init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static let shared = PreferencesController()
  internal var preferencesController:NSWindowController?
  
  #warning("FIX: dispatch this from seperate thread")
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
