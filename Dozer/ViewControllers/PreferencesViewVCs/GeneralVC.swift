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
