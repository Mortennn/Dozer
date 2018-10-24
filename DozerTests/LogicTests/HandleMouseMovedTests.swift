import XCTest
@testable import Dozer

class HandleMouseMovedTests: XCTestCase {
  
  #warning("FIX test")
//  func testHandleMouseMoved() {
//    let dozerStatusItem = DozerStatusItem()
//    let screenHeight = NSScreen.main!.frame.height
//    let statusbarHeight = NSStatusBar.system.thickness
//
//    let inStatusbarCoordinate = NSPoint(x: 200, y: screenHeight-statusbarHeight)
//    let notInStatusbarCoordinate = NSPoint(x: 200, y: screenHeight-statusbarHeight-100)
//
//    // left click - items disappear
//    dozerStatusItem.handleLeftClick()
//
//    // mouse moves, but still in statusbar
//    dozerStatusItem.handleMouseMoved(mouseLocation: inStatusbarCoordinate)
//    XCTAssertTrue(dozerStatusItem.isHidden)
//
//    // mouse moves, but still in statusbar
//    dozerStatusItem.handleMouseMoved(mouseLocation: inStatusbarCoordinate)
//    XCTAssertTrue(dozerStatusItem.isHidden)
//
//    // mouse moves out of menubar
//    dozerStatusItem.handleMouseMoved(mouseLocation: notInStatusbarCoordinate)
//    XCTAssertTrue(dozerStatusItem.isHidden)
//
//    // mouse moves in menu bar
//    dozerStatusItem.handleMouseMoved(mouseLocation: inStatusbarCoordinate)
//    XCTAssertTrue(dozerStatusItem.isShown)
//  }
  
  func testIsMouseInStatusBar() {
    let screenHeight = NSScreen.main!.frame.height
    let statusbarHeight = NSStatusBar.system.thickness
    
    let inStatusbar = NSPoint(x: 200, y: screenHeight-statusbarHeight)
    let notInStatusbar = NSPoint(x: 200, y: screenHeight-statusbarHeight-100)
    
    XCTAssertTrue(isMouseInStatusBar(with: inStatusbar))
    XCTAssertFalse(isMouseInStatusBar(with: notInStatusbar))
  }

}
