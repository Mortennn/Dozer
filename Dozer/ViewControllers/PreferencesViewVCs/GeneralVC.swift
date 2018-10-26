import Cocoa
import MASShortcut
import LaunchAtLogin

class GeneralVC: NSViewController {

  fileprivate var userShortCut: MASShortcut!
  
  @IBOutlet var LaunchAtLoginCheckbox: NSButton!
  @IBOutlet var ToggleMenuItemsView: MASShortcutView!
  @IBOutlet var ShowIconsOnHover: NSButton!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
    
    // create hotkey view
    ToggleMenuItemsView.associatedUserDefaultsKey = UserDefaultKeys.Shortcuts.ToggleMenuItems
    self.view.addSubview(ToggleMenuItemsView)
    
    // shortcut changed
    ToggleMenuItemsView.shortcutValueChange = { (sender) in
      self.userShortCut = self.ToggleMenuItemsView.shortcutValue
    }
  }

  override func viewDidAppear() {
    super.viewDidAppear()
    // set title
    self.view.window?.title = self.title!
    
    // launch at login checkbox
    LaunchAtLoginCheckbox.focusRingType = .none
    if LaunchAtLogin.isEnabled {
      LaunchAtLoginCheckbox.state = .on
    } else {
      LaunchAtLoginCheckbox.state = .off
    }
    
    // show icons on hover
    ShowIconsOnHover.focusRingType = .none
    if UserDefaults.standard.bool(forKey: UserDefaultKeys.ShowIconsOnHover.defaultKey) {
      ShowIconsOnHover.state = .on
    } else {
      ShowIconsOnHover.state = .off
    }

  }
  
  @IBAction func LaunchAtLoginPressed(_ sender: NSButton) {
    LaunchAtLogin.isEnabled = (sender.state == .on)
  }
  
  @IBAction func QuitPressed(_ sender: NSButton) {
    NSApp.terminate(nil)
  }
  
  @IBAction func ShowIconsOnHoverPressed(_ sender: NSButton) {
    if sender.state == .on {
      
    }
    UserDefaults.standard.set(sender.isOn, forKey: UserDefaultKeys.ShowIconsOnHover.defaultKey)
  }
  
}

extension NSButton {
  
  func setStateToOn(state:Bool) {
    if state {
      self.state = .on
    } else {
      self.state = .off
    }
  }
  
  var isOn:Bool {
    get {
      return (state == .on)
    }
  }
  
}
