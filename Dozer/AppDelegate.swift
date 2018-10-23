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
    
    NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { (event) in
      let mouseLocation = NSEvent.mouseLocation
      dozerStatusItem.handleMouseMoved(mouseLocation: mouseLocation)
    }
    
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
