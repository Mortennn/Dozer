import Cocoa

func isMouseInStatusBar(with mouseLocation:NSPoint) -> Bool {
  let mouseLocationY = mouseLocation.y
  
  let statusBarHeight = NSStatusBar.system.thickness
  let screenHeight = NSScreen.main!.frame.height
  
  let offsetY = screenHeight - statusBarHeight

  return (mouseLocationY >= offsetY)
}

class listenForMouseExit {
  
  static let shared = listenForMouseExit()
  
  var mouseHasExited:Bool
  
  private init() {
    mouseHasExited = false
  }
  
  func mouseExited() {
    mouseHasExited = true
  }
}

