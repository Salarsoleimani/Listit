//  
//  SplashNavigator.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import Foundation
import SwiftUI

final class SplashNavigator: Navigator {
  @MainActor func setup() {
    let vm = SplashViewModel(navigator: self, dbManager: servicePackage.dbManager)
    let splashVC = UIHostingController(rootView: SplashView(viewModel: vm))
    navigationController.popViewController(animated: false)
    navigationController.pushViewController(splashVC, animated: true)
  }
  
  @MainActor func toHome() {
    HomeNavigator(navigationController: navigationController, servicePackage: servicePackage).setup()
  }
  
  func toAddTemplates() {
    AddTemplatesNavigator(navigationController: navigationController, servicePackage: servicePackage).setup()
  }
}
