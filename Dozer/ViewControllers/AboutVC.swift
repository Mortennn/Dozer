//
//  AboutVC.swift
//  Dozer
//
//  Created by Morten Nautrup Nielsen on 09/09/2018.
//

import Cocoa

class AboutVC: NSViewController {

  @IBOutlet var VersionLabel: NSTextField!
  
  override func viewDidLoad() {
  super.viewDidLoad()
    self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
  }

  override func viewDidAppear() {
    super.viewDidAppear()
    // set title
    self.view.window?.title = self.title!
    
    // set version
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        VersionLabel.stringValue = "Version: \(version)"
      }
    
  }
  
}
