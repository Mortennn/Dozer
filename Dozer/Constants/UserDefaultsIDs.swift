//
//  UserDefaultsIDs.swift
//  Dozer
//
//  Created by Morten Nautrup Nielsen on 09/09/2018.
//

import Cocoa

struct UserDefaultKeys {
  private init(){}
  struct Shortcuts {
    private init(){}
    #if !DEBUG
      static let ToggleMenuItems = "toggleMenuItems"
    #else
      static let ToggleMenuItems = "toggleMenuItemsDEBUG"
    #endif
  }
  struct FirstRun {
    private init(){}
    #if !DEBUG
      static let defaultKey = "firstRun"
    #else
      static let defaultKey = "firstRunDEBUG"
    #endif
  }
  struct Theme {
    private init(){}
    #if !DEBUG
    static let darkmode = "darkIcon"
    #else
    static let darkmode = "darkIconDEBUG"
    #endif
    
    #if !DEBUG
    static let autochange = "autoChangeIconTheme"
    #else
    static let autochange = "autoChangeIconThemeDEBUG"
    #endif
  }
}

struct StoryboardNames {
  private init(){}
    static let Preferences = NSStoryboard.Name("Preferences")
}
