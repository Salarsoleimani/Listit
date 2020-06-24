//  
//  SettingNavigator.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-23.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

final class SettingNavigator: Navigator {
  func setup() {
    let vc = SettingController(navigator: self)
    navigationController.pushViewController(vc, animated: true)
  }
}
