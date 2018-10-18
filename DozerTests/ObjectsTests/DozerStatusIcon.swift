//
//  DozerStatusIcon.swift
//  DozerTests
//
//  Created by Morten Nautrup Nielsen on 18/10/2018.
//

import XCTest
@testable import Dozer

class DozerStatusIcon: XCTestCase {
  
  func testDozerStatusItemInit() {
    let dozerStatusItem = DozerStatusItem()
    assert(dozerStatusItem.statusItem.length == dozerStatusItem.shownLength)
    assert(dozerStatusItem.statusItem.button?.image?.name() == Icons().shown.name())
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
  
  func testIsShown() {
    let dozerStatusItem = DozerStatusItem()
    assert(dozerStatusItem.isShown == (dozerStatusItem.statusItem.length == dozerStatusItem.shownLength))
  }
  
  func testIsHidden() {
    let dozerStatusItem = DozerStatusItem()
    assert(dozerStatusItem.isHidden == (dozerStatusItem.statusItem.length == dozerStatusItem.hiddenLength))
  }
  
  func testCreateMenu() {
    let menu = DozerStatusItem().createMenu()
    
    let about = menu.item(at: 0)!
    XCTAssertNotNil(menu.item(at: 1)) // seperator
    let preferences = menu.item(at: 2)!
    XCTAssertNotNil(menu.item(at: 3)) // seperator
    let quit = menu.item(at: 4)!
    
    assert(about.title == "About")
    assert(preferences.title == "Preferences")
    assert(quit.title == "Quit")
    
    assert(about.keyEquivalent == "")
    assert(preferences.keyEquivalent == ",")
    assert(quit.keyEquivalent == "q")
    
    XCTAssertNotNil(about.action)
    XCTAssertNotNil(preferences.action)
    XCTAssertNotNil(quit.action)
    
  }
}
