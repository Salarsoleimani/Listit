//
//  HomeNavigator.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation
import Haptico

final class HomeNavigator: Navigator {
  func setup() {
    let vc = HomeController(navigator: self, dbManager: servicePackage.dbManager)
    navigationController.pushViewController(vc, animated: true)
    navigationController.viewControllers = [vc]
  }
  func toAddOrEditList(list: List?, delegate: HomeControllerDelegate) {
    Haptico.shared().generate(.light)
    AddListNavigator(navigationController: navigationController, servicePackage: servicePackage).setup(list: list, delegate: delegate)
  }
  
  func toAddOrEditItem(item: Item?, forList: List?, lists: [List], allItemsList: List?, itemTitle: String = "") {
    Haptico.shared().generate(.light)
    AddItemNavigator(navigationController: navigationController, servicePackage: servicePackage).setup(item: item, parentList: forList, lists: lists, allItemsList: allItemsList, itemTitle: itemTitle)
  }
}
