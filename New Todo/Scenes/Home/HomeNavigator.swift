//
//  HomeNavigator.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

final class HomeNavigator: Navigator {
  func setup() {
    let vc = HomeController(navigator: self, dbManager: servicePackage.dbManager)
    
    navigationController.viewControllers = [vc]
    //AnalyticLogProvider.logNavigator(name: NSStringFromClass(type(of: self)), functionName: "setup")
  }
  func toAddList() {
    AddListNavigator(navigationController: navigationController, servicePackage: servicePackage).setup()
  }
  
  func toAddItem(forList: List?, lists: [List]) {
    AddItemNavigator(navigationController: navigationController, servicePackage: servicePackage).setup(parentList: forList, lists: lists)
  }
}
