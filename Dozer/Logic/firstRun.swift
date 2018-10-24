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
<<<<<<< HEAD:Dozer/Logic/firstRun.swift
  print(isNotFirstRun)
=======
>>>>>>> v2:Dozer/Logic/FirstRun.swift

  // comment this to test first run
  if isNotFirstRun {
    return
  }
  
  // show boarding screen
  let boardingScreen = BoardingScreen()
  boardingScreen.show()
  
  // set changeThemeAutomatically to true
  UserDefaults.standard.set(true, forKey: UserDefaultKeys.Theme.autochange)

  UserDefaults.standard.set(true, forKey: UserDefaultKeys.FirstRun.defaultKey)
}
