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
    
    dozerStatusItem.show()
    
    NSEvent.addLocalMonitorForEvents(matching: .mouseMoved) { (event) -> NSEvent? in
      let mouseLocation = event.locationInWindow
      dozerStatusItem.handleMouseMoved(mouseLocation: mouseLocation)
      return event
    }
    
    NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { (event) in
      let mouseLocation = event.locationInWindow
      dozerStatusItem.handleMouseMoved(mouseLocation: mouseLocation)
    }
    
    // bind global shortcut
    MASShortcutBinder.shared()?.bindShortcut(withDefaultsKey: UserDefaultKeys.Shortcuts.ToggleMenuItems, toAction: {
      dozerStatusItem.toggle()
    })
    
    #warning("first run is not enabled")
    firstRun()

  }

  
  @objc func showPreferences() {
    PreferencesController.shared.showPreferencesPane()
  }
  
}
