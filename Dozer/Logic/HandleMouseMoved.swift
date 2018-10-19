import Cocoa

func handleMouseMoved() {
  #warning("FIX: animation missing")
  NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { (event) in
    let mouseLocation = NSEvent.mouseLocation
    print(dozerStatusItem.isMenuShown())
    if isMouseInStatusBar(with: mouseLocation) {
      dozerStatusItem.show()
    } else {
      dozerStatusItem.hide()
      dozerStatusItem.hideMenu()
      dozerStatusItem.statusItem.button!.isHighlighted = false
    }
  }
}

#warning("FIX: handle multiple screens")
func isMouseInStatusBar(with mouseLocation:NSPoint) -> Bool {
  let mouseLocationY = mouseLocation.y
  
  let statusBarHeight = NSStatusBar.system.thickness
  let screenHeight = NSScreen.main!.frame.height
  
  let offsetY = screenHeight - statusBarHeight

  return (mouseLocationY >= offsetY)
}
