import Cocoa

class DozerStatusItem {
  
  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  
  let shownLength:CGFloat = 20
  let hiddenLength:CGFloat = 10000
  
  init() {
    statusItem.length = shownLength
    if let mainStatusItemButton = statusItem.button {
      mainStatusItemButton.target = self
      mainStatusItemButton.action = #selector(mainMenuItemClicked(sender:))
      mainStatusItemButton.image = Icons().shown
      mainStatusItemButton.sendAction(on: [.leftMouseDown, .rightMouseDown])
    }
  }
  
  deinit {
    print("status item has been deallocated")
  }
  
  public func show() {
    statusItem.length = shownLength
  }
  
  func hidden() {
    statusItem.length = hiddenLength
  }
  
  @objc func mainMenuItemClicked(sender: AnyObject?) {
    print("main menu item clicked")
    guard let currentEvent = NSApp.currentEvent else {
      NSLog("read current event failed")
      return
    }
    
    if currentEvent.type == NSEvent.EventType.leftMouseDown {
      let tmpView = NSView(frame: statusItem.button!.frame)
      statusItem.button!.addSubview(tmpView)
      let menu = createMenu(in: tmpView)
      statusItem.button!.menu = menu
    }
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
  
}
