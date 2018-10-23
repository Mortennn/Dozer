import Cocoa

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
}
