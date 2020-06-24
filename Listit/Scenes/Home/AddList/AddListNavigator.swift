//  
//  AddListNavigator.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

final class AddListNavigator: Navigator {
  func setup(list: List?) {
    let vc = AddListController(navigator: self, dbManager: servicePackage.dbManager)
    vc.list = list
    navigationController.pushViewController(vc, animated: true)
  }
  func toIconSelector(delegate: AddListControllerDelegate, listTitle: String) {
    IconsNavigator(navigationController: navigationController, servicePackage: servicePackage).setup(delegate: delegate, listTitle: listTitle)
  }
  func pop() {
    navigationController.popViewController(animated: true)
  }
}
