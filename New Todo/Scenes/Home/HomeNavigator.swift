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
  func toAddOrEditList(list: List?) {
    AddListNavigator(navigationController: navigationController, servicePackage: servicePackage).setup(list: list)
  }
  
  func toAddOrEditItem(item: Item?, forList: List?, lists: [List], allItemsList: List?) {
    AddItemNavigator(navigationController: navigationController, servicePackage: servicePackage).setup(item: item, parentList: forList, lists: lists, allItemsList: allItemsList)
  }
}
