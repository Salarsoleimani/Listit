//  
//  SplashViewModel.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation
import UIKit

final class SplashViewModel {
  
  private let navigator: SplashNavigator
  let scalePop: CGFloat = 0.05
  init( navigator: SplashNavigator) {
    self.navigator = navigator
  }
  func goToHomePage(handler: (()->())?) {
    navigator.toHome()
  }
}
