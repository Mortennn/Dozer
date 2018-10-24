import Cocoa

// legacy
//func isMouseInStatusBar(with mouseLocation:NSPoint) -> Bool {
//  let mouseLocationY = mouseLocation.y
//
//  let statusBarHeight = NSStatusBar.system.thickness
//  let screenHeight = NSScreen.main!.frame.height
//  let screenWidth = NSScreen.main!.frame.width
//
//  let offsetY = screenHeight - statusBarHeight
//  let offsetX = screenWidth - statusBarHeight
//
//  return (mouseLocationY >= offsetY)
//}

func isMouseInStatusBar(with mouseLocation:NSPoint) -> Bool {
  
  let statusBarHeight = NSStatusBar.system.thickness
  
  for screen in NSScreen.screens {
    
    let screenX = screen.frame.origin.x
    let screenY = screen.frame.origin.y
    let screenHeight = screen.frame.height
    let screenWidth = screen.frame.width
    
    // starting screen
    if screenX == 0 && screenY == 0 {
      if (mouseLocation.x <= screenWidth), (mouseLocation.y >= screenHeight - statusBarHeight), (mouseLocation.y <= screenHeight) {
        return true
      }
      // everything else
    } else {
      if (mouseLocation.y>=screenHeight+screenY-statusBarHeight) && (mouseLocation.y <= screenY + screenHeight) {
        return true
      }
    }
  }
  
  return false
}

class listenForMouseExit {
  
  static let shared = listenForMouseExit()
  
  var mouseHasExited:Bool
  
  private init() {
    mouseHasExited = false
  }
  
}

