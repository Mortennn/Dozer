import AXSwift
import Cocoa

func getLastMenuItemXPosition(from app:NSRunningApplication) -> CGFloat {
  if !UIElement.isProcessTrusted(withPrompt: true) { return 0 }
  guard let uiApp = Application(app) else {
    return 0
  }

  var menuItemRightPosition:[CGFloat] = [0]
  do {
    if let menuBar: UIElement = try uiApp.attribute(.menuBar) {
      if let menuItems:[AXUIElement] = try menuBar.attribute(.children) {
        for (_, menuItem) in menuItems.enumerated() {
          if let frame:NSRect = try UIElement(menuItem).attribute(.frame) {
            let rightPosition = frame.origin.x + frame.width
            menuItemRightPosition.append(rightPosition)
          }
        }
      }
    }
  } catch {
    print(error)
  }
  
  guard let closestMenuItemFrame = menuItemRightPosition.max() else {
    return 0
  }
  
  return closestMenuItemFrame
}
