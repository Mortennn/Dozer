import XCTest
@testable import Dozer

class HandleMouseMovedTests: XCTestCase {
  
  func testIsMouseInStatusBar() {
    #warning("use the screen height in the calculations")
    let inStatusbar = NSPoint(x: 800, y: 800)
    let notInStatusbar = NSPoint(x: 0, y: 0)
    
    XCTAssertTrue(isMouseInStatusBar(with: inStatusbar))
    XCTAssertFalse(isMouseInStatusBar(with: notInStatusbar))
  }
}
