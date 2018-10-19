import Cocoa

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
