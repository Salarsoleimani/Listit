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
  func toAddOrEditList(list: List?, delegate: HomeControllerDelegate) {
    AddListNavigator(navigationController: navigationController, servicePackage: servicePackage).setup(list: list, delegate: delegate)
  }
  
  func toAddOrEditItem(item: Item?, forList: List?, lists: [List], delegate: HomeControllerDelegate ) {
    AddItemNavigator(navigationController: navigationController, servicePackage: servicePackage).setup(parentList: forList, lists: lists, delegate: delegate)
  }
}
