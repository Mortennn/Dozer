import Cocoa
import MASShortcut
import Fabric
import Crashlytics

let dozerStatusItem = DozerStatusItem()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  func applicationDidFinishLaunching(_ notification: Notification) {
    
    UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions" : true])
    Fabric.with([Crashlytics.self])
    
    dozerStatusItem.show()
    
    NSEvent.addLocalMonitorForEvents(matching: .mouseMoved) { (event) -> NSEvent? in
      let mouseLocation = NSEvent.mouseLocation
      dozerStatusItem.handleMouseMoved(mouseLocation: mouseLocation)
      return event
    }
    
    NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { (event) in
      let mouseLocation = NSEvent.mouseLocation
      dozerStatusItem.handleMouseMoved(mouseLocation: mouseLocation)
    }
    
    // bind global shortcut
    MASShortcutBinder.shared()?.bindShortcut(withDefaultsKey: UserDefaultKeys.Shortcuts.ToggleMenuItems, toAction: {
      dozerStatusItem.toggle()
    })
    
    firstRun()

  }

  
  @objc func showPreferences() {
    PreferencesController.shared.showPreferencesPane()
  }
  
}
