//
//  firstRun.swift
//  Dozer
//
//  Created by Morten Nautrup Nielsen on 02/10/2018.
//

import Foundation

func firstRun() {
  
  // check if first run
  let isNotFirstRun = UserDefaults.standard.bool(forKey: UserDefaultKeys.FirstRun.defaultKey)

  // comment this to test first run
  if isNotFirstRun {
    return
  }
  
  // show boarding screen
  let boardingScreen = BoardingScreen()
  boardingScreen.show()

  UserDefaults.standard.set(true, forKey: UserDefaultKeys.FirstRun.defaultKey)
}
