import Cocoa
import AXSwift

class DozerStatusItem {
  
  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  
  let shownLength:CGFloat = 20
  let hiddenLength:CGFloat = 10000
  
  init() {
    statusItem.length = shownLength
    
    guard let mainStatusItemButton = statusItem.button else {
      fatalError("main status item button failed")
    }
    
    mainStatusItemButton.target = self
    mainStatusItemButton.action = #selector(statusItemClicked(sender:))
    mainStatusItemButton.image = Icons().statusBarIcon
    mainStatusItemButton.image!.isTemplate = true
    mainStatusItemButton.sendAction(on: [.leftMouseDown, .rightMouseDown])
  }
  
  deinit {
    print("status item has been deallocated")
  }
  
  func show() {
    statusItem.length = shownLength
  }
  
  func hide() {
    statusItem.length = hiddenLength
  }
  
  func toggle() {
    if isShown {
      hide()
    } else {
      show()
    }
  }
  
  @objc func statusItemClicked(sender: AnyObject?) {
    guard let currentEvent = NSApp.currentEvent else {
      NSLog("read current event failed")
      return
    }
    
    if currentEvent.type == NSEvent.EventType.leftMouseDown {
      handleLeftClick()
    }
    
    if currentEvent.type == NSEvent.EventType.rightMouseDown {
      handleRightClick()
    }
  }
  
  internal func handleLeftClick() {
    self.hide()
  }
  
  internal func handleRightClick() {
    PreferencesController.shared.showPreferencesPane()
  }
  
  var isShown:Bool {
    get {
      return (statusItem.length == shownLength)
    }
  }
  
  var isHidden:Bool {
    get {
      return (statusItem.length == hiddenLength)
    }
  }
  
  internal func handleMouseMoved(mouseLocation:NSPoint) {
    if isMouseInStatusBar(with: mouseLocation) && listenForMouseExit.shared.mouseHasExited {
      self.show()
      listenForMouseExit.shared.mouseHasExited = false
    } else if !isMouseInStatusBar(with: mouseLocation) {
      listenForMouseExit.shared.mouseHasExited = true
    }
  }
  
  internal func handleClickOnMenuBar(mouseLocation:NSPoint) {
    if isMouseInStatusBarSaveSpace(with: mouseLocation) {
      self.show()
    }
  }
  
  func isMouseInStatusBarSaveSpace(with mouseLocation:NSPoint) -> Bool {
    
    let statusBarHeight = NSStatusBar.system.thickness
    guard let menuBarOwningApp = NSWorkspace.shared.menuBarOwningApplication else {
      fatalError()
    }
    
    for screen in NSScreen.screens {
      var frame = screen.frame
      frame.origin.y = frame.origin.y + frame.height - statusBarHeight - 2
      frame.size.height = statusBarHeight + 3
      frame.origin.x = getLastMenuItemXPosition(from: menuBarOwningApp)
      frame.size.width = xPositionOnScreen - frame.origin.x + shownLength
      if frame.contains(mouseLocation) {
        return true
      }
    }
    
    return false
  }
  
  internal var xPositionOnScreen:CGFloat {
    get {
      guard let dozerIconFrame = statusItem.button?.window?.frame else {
        return 0
      }
      let dozerIconXPosition = dozerIconFrame.origin.x + dozerIconFrame.width - shownLength
      return dozerIconXPosition
    }
  }
  
}
