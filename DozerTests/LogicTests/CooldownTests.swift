import XCTest
@testable import Dozer

class CooldownTests: XCTestCase {

  func testInit() {
    let cooldownPeriod:TimeInterval = 2
    let cooldown = Cooldown(seconds: cooldownPeriod)
    assert(cooldown.cooldownPeriod == cooldownPeriod)
  }
  
  func testStart() {
    let cooldownPeriod:TimeInterval = 2
    let cooldown = Cooldown(seconds: cooldownPeriod)
    cooldown.start()
    assert(cooldown.startTime < Date().timeIntervalSince1970)
  }
  
  func testReset() {
    let cooldownPeriod:TimeInterval = 2
    let cooldown = Cooldown(seconds: cooldownPeriod)
    cooldown.start()
    assert(cooldown.startTime < Date().timeIntervalSince1970)
  }
  
  func testIsFinished() {
    let cooldownPeriod:TimeInterval = 2
    let cooldown = Cooldown(seconds: cooldownPeriod)
    cooldown.start()
    #warning("wait for cooldown period")
//    XCTAssertTrue(cooldown.isFinished)
  }
  
}
