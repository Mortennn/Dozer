//
//  GeneralVC.swift
//  Dozer
//
//  Created by Morten Nautrup Nielsen on 07/09/2018.
//

import Cocoa
import MASShortcut
import LaunchAtLogin

class GeneralVC: NSViewController {

  fileprivate var userShortCut: MASShortcut!
  
  @IBOutlet var LaunchAtLoginCheckbox: NSButton!
  @IBOutlet var ToggleMenuItemsView: MASShortcutView!
<<<<<<< HEAD:Dozer/ViewControllers/GeneralVC.swift
  @IBOutlet var CheckForUpdates: NSButton!
  @IBOutlet var EnableDarkModeCheckbox: NSButton!
  @IBOutlet var ChangeThemeAutomatically: NSButton!
=======
>>>>>>> v2:Dozer/ViewControllers/PreferencesViewVCs/GeneralVC.swift
  
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
<<<<<<< HEAD:Dozer/ViewControllers/GeneralVC.swift
  
  override func viewWillAppear() {
    super.viewWillAppear()

    let defaults = UserDefaults.standard
    
    let changeThemeAutomaticallyBool = defaults.bool(forKey: UserDefaultKeys.Theme.autochange)
    ChangeThemeAutomatically.setStateToOn(state: changeThemeAutomaticallyBool)
    
    let darkmodeBool = defaults.bool(forKey: UserDefaultKeys.Theme.darkmode)
    EnableDarkModeCheckbox.setStateToOn(state: darkmodeBool)

    EnableDarkModeCheckbox.isHidden = (changeThemeAutomaticallyBool == true)

    
  }
  
=======

>>>>>>> v2:Dozer/ViewControllers/PreferencesViewVCs/GeneralVC.swift
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

  }
  
  
  @IBAction func ChangeThemeAutomaticallyPressed(_ sender: NSButton) {
    UserDefaults.standard.set(
      (sender.state == .on),
      forKey: UserDefaultKeys.Theme.autochange
    )
    EnableDarkModeCheckbox.isHidden = (sender.state == .on)
    changeAppTheme(toDarkMode: nil)
  }
  
  @IBAction func EnableDarkModeCheckboxPressed(_ sender: NSButton) {
    UserDefaults.standard.set(
      (sender.state == .on),
      forKey: UserDefaultKeys.Theme.darkmode
    )
    changeAppTheme(toDarkMode: (sender.state == .on))
  }
  
  func changeAppTheme(toDarkMode darkmode:Bool?) {
    if mainStatusItem.isExpanded {
      showStatusItems() // FIXME: status items get showed, even when they shouldn't
    } else {
      mainStatusItem.button!.image = Icons().shown
    }
  }
  
  @IBAction func LaunchAtLoginPressed(_ sender: NSButton) {
    LaunchAtLogin.isEnabled = (sender.state == .on)
  }
  
  @IBAction func QuitPressed(_ sender: NSButton) {
    NSApp.terminate(nil)
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
  
}
