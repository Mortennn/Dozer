import Cocoa
import MASShortcut
import Fabric
import Crashlytics
import AXSwift
import Sparkle

private let dozerStatusItem = DozerStatusItem()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  func applicationDidFinishLaunching(_ notification: Notification) {
    
    UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions" : true])
    Fabric.with([Crashlytics.self])
   
    firstRun()
    
  }
  
  func continueAppLife() {
    dozerStatusItem.show()
    
    // Menu Bar Hover
    NSEvent.addLocalMonitorForEvents(matching: .mouseMoved) { (event) -> NSEvent? in
      if !UserDefaults.standard.bool(forKey: UserDefaultKeys.ShowIconsOnHover.defaultKey) {
        return event
      }
      let mouseLocation = NSEvent.mouseLocation
      dozerStatusItem.handleMouseMoved(mouseLocation: mouseLocation)
      return event
    }
    
    NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { (_) in
      if !UserDefaults.standard.bool(forKey: UserDefaultKeys.ShowIconsOnHover.defaultKey) {
        return
      }
      let mouseLocation = NSEvent.mouseLocation
      dozerStatusItem.handleMouseMoved(mouseLocation: mouseLocation)
    }
    
    // Menu Bar Click
    NSEvent.addGlobalMonitorForEvents(matching: .leftMouseUp) { (_) in
      if UserDefaults.standard.bool(forKey: UserDefaultKeys.ShowIconsOnHover.defaultKey) {
        return
      }
      let mouseLocation = NSEvent.mouseLocation
      dozerStatusItem.handleClickOnMenuBar(mouseLocation: mouseLocation)
    }
    
    // bind global shortcut
    MASShortcutBinder.shared()?.bindShortcut(
      withDefaultsKey: UserDefaultKeys.Shortcuts.ToggleMenuItems,
      toAction: {
        dozerStatusItem.toggle()
    })
    
    SUUpdater.shared()?.automaticallyChecksForUpdates = true
  }

  @objc func showPreferences() {
    PreferencesController.shared.showPreferencesPane()
  }
  
}
