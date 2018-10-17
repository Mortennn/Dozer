//
//  GlobalSettings.swift
//  Dozer
//
//  Created by Mortennn on 10/08/2018.
//

import Cocoa

struct Icons {
  
  private var imageName:String!
  
  init() {

    let autochange = UserDefaults.standard.bool(forKey: UserDefaultKeys.Theme.autochange)
    let darkmode = UserDefaults.standard.bool(forKey: UserDefaultKeys.Theme.darkmode)
    
    if !autochange {
      if darkmode {
        imageName = "StatusBarIconBlack"
      } else {
        imageName = "StatusBarIconWhite"
      }
    } else if isSystemAppearenceDark {
      imageName = "StatusBarIconWhite"
    } else {
      imageName = "StatusBarIconBlack"
    }
  }
  
  var shown : NSImage {
    get {
      return create(image: imageName, 10, 10)
    }
  }
  
  var hidden : NSImage {
    get {
      return create(image: imageName, 15, 15)
    }
  }
  
  private func create(image name:String, _ width:Int, _ height:Int) -> NSImage {
    guard let image = NSImage(named: NSImage.Name(name)) else {
      fatalError("get image failed")
    }
    image.size = NSSize(width: width, height: height)
    return image
  }
}

var isSystemAppearenceDark:Bool {
  get {
    let currentAppearence = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
    UserDefaults.standard.removeObject(forKey: "AppleInterfaceStyle")
    if currentAppearence == "Light" {
      return false
    } else {
      return true
    }
  }
}

