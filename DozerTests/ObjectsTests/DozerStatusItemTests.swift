import XCTest
@testable import Dozer

class DozerStatusItemTests: XCTestCase {
  
  func testDozerStatusItemInit() {
    let dozerStatusItem = DozerStatusItem()
    assert(dozerStatusItem.statusItem.length == dozerStatusItem.shownLength)
    assert(dozerStatusItem.statusItem.button?.image?.name() == Icons().statusBarIcon.name())
    NSStatusBar.system.removeStatusItem(dozerStatusItem.statusItem)
  }
  
  func testShow() {
    let dozerStatusItem = DozerStatusItem()
    dozerStatusItem.show()
    assert(dozerStatusItem.statusItem.length == dozerStatusItem.shownLength)
  }
  
  func testHide() {
    let dozerStatusItem = DozerStatusItem()
    dozerStatusItem.hide()
    assert(dozerStatusItem.statusItem.length == dozerStatusItem.hiddenLength)
  }
  
  func testToggle() {
    let dozerStatusItem = DozerStatusItem()
    dozerStatusItem.hide()
    dozerStatusItem.toggle()
    assert(dozerStatusItem.statusItem.length == dozerStatusItem.shownLength)
  }
  
  func testHandleLeftClick() {
    let dozerStatusItem = DozerStatusItem()
    dozerStatusItem.handleLeftClick()
    XCTAssertTrue(dozerStatusItem.isHidden)
 }
  
  func testHandleRightClick() {
    let dozerStatusItem = DozerStatusItem()
    dozerStatusItem.handleRightClick()
    guard let frontmostApp = NSWorkspace.shared.frontmostApplication?.localizedName else {
      XCTFail()
      return
    }
    XCTAssertTrue(frontmostApp == "Dozer")
    guard let preferencesWindow = PreferencesController.shared.preferencesController else {
      XCTFail()
      return
    }
    preferencesWindow.close()
    PreferencesController.shared.preferencesController = nil
  }
  
  func testIsShown() {
    let dozerStatusItem = DozerStatusItem()
    assert(dozerStatusItem.isShown == (dozerStatusItem.statusItem.length == dozerStatusItem.shownLength))
  }
  
  func testIsHidden() {
    let dozerStatusItem = DozerStatusItem()
    assert(dozerStatusItem.isHidden == (dozerStatusItem.statusItem.length == dozerStatusItem.hiddenLength))
  }
  
  func testHandleClickOnMenuBar() {
    let screenHeight = NSScreen.main!.frame.height
    let statusbarHeight = NSStatusBar.system.thickness
    
    let inStatusbar = NSPoint(x: 200, y: screenHeight-statusbarHeight)
    let notInStatusbar = NSPoint(x: 200, y: screenHeight-statusbarHeight-100)
    
    XCTAssertTrue(isMouseInStatusBar(with: inStatusbar))
    XCTAssertFalse(isMouseInStatusBar(with: notInStatusbar))
  }
  
  // single running works
  func testIsMouseInStatusBarSaveSpace() {
    let statusItem = DozerStatusItem()

    let screenFrame = NSScreen.main!.frame
    let screenHeight = screenFrame.height
    let statusbarHeight = NSStatusBar.system.thickness
    let dozerIconXPos = statusItem.xPositionOnScreen
    
    let inStatusbar = NSPoint(x: dozerIconXPos-10, y: screenHeight-statusbarHeight)
    let notInStatusbarLeft = NSPoint(x: 2, y: screenHeight-statusbarHeight)
    let notInStatusbarRight = NSPoint(x: screenFrame.width-2, y: screenHeight-statusbarHeight)
    
    XCTAssertTrue(statusItem.isMouseInStatusBarSaveSpace(with: inStatusbar))
    XCTAssertFalse(statusItem.isMouseInStatusBarSaveSpace(with: notInStatusbarLeft))
    XCTAssertFalse(statusItem.isMouseInStatusBarSaveSpace(with: notInStatusbarRight))
  }
  
  func testXPositionOnScreen() {
    // test that the x pos is the same in hidden/shown mode
    let dozerStatusItem = DozerStatusItem()
    dozerStatusItem.show()
    let shownXPosition = dozerStatusItem.xPositionOnScreen

    dozerStatusItem.hide()
    let hiddenXPosition = dozerStatusItem.xPositionOnScreen
    
    XCTAssertEqual(shownXPosition, hiddenXPosition)
  }
  
//  func testCreateMenu() {
//    let menu = DozerStatusItem().createMenu()
//
//    let about = menu.item(at: 0)!
//    XCTAssertNotNil(menu.item(at: 1)) // seperator
//    let preferences = menu.item(at: 2)!
//    XCTAssertNotNil(menu.item(at: 3)) // seperator
//    let quit = menu.item(at: 4)!
//
//    assert(about.title == "About")
//    assert(preferences.title == "Preferences")
//    assert(quit.title == "Quit")
//
//    assert(about.keyEquivalent == "")
//    assert(preferences.keyEquivalent == ",")
//    assert(quit.keyEquivalent == "q")
//
//    XCTAssertNotNil(about.action)
//    XCTAssertNotNil(preferences.action)
//    XCTAssertNotNil(quit.action)
//
//  }
//
//  func testShowMenu() {
//    // not possible to unit test due to dispatch block
//  }
//
//  func testHideMenu() {
//    // not possible to unit test due to dispatch block
//  }
}
