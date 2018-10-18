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
  
  #warning("Test freezes")
  func testHandleLeftClick() {
    let dozerStatusItem = DozerStatusItem()
    dozerStatusItem.handleLeftClick()
    
  }
  
  func testIsShown() {
    let dozerStatusItem = DozerStatusItem()
    assert(dozerStatusItem.isShown == (dozerStatusItem.statusItem.length == dozerStatusItem.shownLength))
  }
  
  func testIsHidden() {
    let dozerStatusItem = DozerStatusItem()
    assert(dozerStatusItem.isHidden == (dozerStatusItem.statusItem.length == dozerStatusItem.hiddenLength))
  }
  
}
