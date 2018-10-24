import Cocoa

func isMouseInStatusBar(with mouseLocation:NSPoint) -> Bool {
  
  let statusBarHeight = NSStatusBar.system.thickness
  
  for screen in NSScreen.screens {
    var frame = screen.frame
    frame.origin.y = frame.origin.y + frame.height - statusBarHeight - 2
    frame.size.height = statusBarHeight + 3
    if frame.contains(mouseLocation) {
      return true
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

