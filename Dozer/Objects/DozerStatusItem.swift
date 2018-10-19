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
    mainStatusItemButton.image = Icons().shown
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
    print("main menu item clicked")
    guard let currentEvent = NSApp.currentEvent else {
      NSLog("read current event failed")
      return
    }
    
    if currentEvent.type == NSEvent.EventType.leftMouseDown {
      handleLeftClick()
    }
  }
  
  internal func handleLeftClick() {
    showMenu()
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
  
  internal func createMenu() -> NSMenu {
    let menu = NSMenu()
    
    #warning("FIX: menu items")
    #warning("FIX: About should open preferences about")
    let about = NSMenuItem(title: "About", action: #selector(NSApp.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
    let preferences = NSMenuItem(title: "Preferences", action: #selector(AppDelegate.showPreferences), keyEquivalent: ",")
    let quit = NSMenuItem(title: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q")
    
    menu.addItem(about)
    menu.addItem(NSMenuItem.separator())
    menu.addItem(preferences)
    menu.addItem(NSMenuItem.separator())
    menu.addItem(quit)
    
    return menu
  }
  
  internal func showMenu() {
    // not possible to unit test due to dispatch block
    if statusItem.menu == nil {
      statusItem.menu = createMenu()
    }
    statusItem.popUpMenu(statusItem.menu!)
  }
  
  internal func hideMenu() {
    // not possible to unit test due to dispatch block
    statusItem.menu = nil
    statusItem.menu = createMenu()
  }
  
  #warning("FIX: remove the menu when icons are hidden")
  func isMenuShown() -> Bool {
    guard let isHighlighted = statusItem.button?.isHighlighted else {
      return false
    }
    // statusItem clicked and icons
    return (isHighlighted && isShown)
  }
  
}
