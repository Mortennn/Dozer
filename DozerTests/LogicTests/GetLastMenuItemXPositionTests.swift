import XCTest
@testable import Dozer

class GetLastMenuItemXPositionTests: XCTestCase {

  func testGetLastMenuItemXPosition() {
    guard let menuBarOwningApp = NSWorkspace.shared.menuBarOwningApplication else {
      XCTFail("Failed in getting menu bar owning app")
      return
    }
    let XPosition = getLastMenuItemXPosition(from: menuBarOwningApp)
    
    assert(XPosition > 0)
    assert(XPosition < NSScreen.main!.frame.width)
  }
  
}
