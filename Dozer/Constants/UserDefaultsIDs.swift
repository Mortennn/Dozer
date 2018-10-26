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
      static let defaultKey = "firstRunV2.1.0"
    #else
      static let defaultKey = "firstRunV2.1.0DEBUG"
    #endif
  }
  struct ShowIconsOnHover {
    private init(){}
    #if !DEBUG
    static let defaultKey = "showIconsOnHover"
    #else
    static let defaultKey = "showIconsOnHoverDEBUG"
    #endif
  }
}

struct StoryboardNames {
  private init(){}
    static let Preferences = NSStoryboard.Name("Preferences")
}
