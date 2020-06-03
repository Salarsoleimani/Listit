//  
//  SplashNavigator.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

final class SplashNavigator: Navigator {
  func setup() {
    let vc = SplashController.initFromNib()
    vc.viewModel = SplashViewModel(navigator: self)
    navigationController.viewControllers = [vc]
    //AnalyticLogProvider.logNavigator(name: NSStringFromClass(type(of: self)), functionName: "setup")
  }
  
  func toHome() {
    HomeNavigator(navigationController: navigationController, servicePackage: servicePackage).setup()
  }
}
