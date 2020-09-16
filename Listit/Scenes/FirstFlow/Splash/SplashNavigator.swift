//  
//  SplashNavigator.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import Foundation

final class SplashNavigator: Navigator {
  func setup() {
    let vc = SplashController.initFromNib()
    vc.viewModel = SplashViewModel(navigator: self, dbManager: servicePackage.dbManager)
    navigationController.popViewController(animated: false)
    navigationController.pushViewController(vc, animated: true)
    //AnalyticLogProvider.logNavigator(name: NSStringFromClass(type(of: self)), functionName: "setup")
  }
  
  func toHome() {
    HomeNavigator(navigationController: navigationController, servicePackage: servicePackage).setup()
  }
  func toAddTemplates() {
    AddTemplatesNavigator(navigationController: navigationController, servicePackage: servicePackage).setup()
  }
}
