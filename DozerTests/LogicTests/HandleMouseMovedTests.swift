import XCTest
@testable import Dozer

class HandleMouseMovedTests: XCTestCase {
  
  func testIsMouseInStatusBar() {
    #warning("use the screen height in the calculations")
    let inStatusbar = NSPoint(x: 200, y: 780)
    let notInStatusbar = NSPoint(x: 200, y: 500)
    
    XCTAssertTrue(isMouseInStatusBar(with: inStatusbar))
    XCTAssertFalse(isMouseInStatusBar(with: notInStatusbar))
  }
}
