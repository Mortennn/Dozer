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
}

struct StoryboardNames {
  private init(){}
    static let Preferences = NSStoryboard.Name("Preferences")
}
