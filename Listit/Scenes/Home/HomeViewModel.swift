//
//  HomeViewModel.swift
//  Listit
//
//  Created by Salar Soleimani on 2024-04-15.
//  Copyright © 2024 SaSApps. All rights reserved.
//

import Foundation

class HomeViewModel: ObservableObject {
  let navigator: HomeNavigator
  
  init(navigator: HomeNavigator) {
    self.navigator = navigator
  }
}
