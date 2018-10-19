import Cocoa

#warning("FIX: handle multiple screens")
func isMouseInStatusBar(with mouseLocation:NSPoint) -> Bool {
  let mouseLocationY = mouseLocation.y
  
  let statusBarHeight = NSStatusBar.system.thickness
  let screenHeight = NSScreen.main!.frame.height
  
  let offsetY = screenHeight - statusBarHeight
  print(mouseLocationY, offsetY)
  return (mouseLocationY >= offsetY)
}
