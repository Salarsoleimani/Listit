//  
//  AddItemNavigator.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-06.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation
import SwiftLocalNotification

final class AddItemNavigator: Navigator {
  func setup(item: Item?, parentList: List?, lists: [List], allItemsList: List?) {
    let vc = AddItemController(navigator: self, dbManager: servicePackage.dbManager)
    vc.parentList = parentList
    vc.lists = lists
    vc.item = item
    vc.allItemsList = allItemsList
    navigationController.pushViewController(vc, animated: true)
  }
  func toDateSelection(date: Date?, repeating: RepeatingInterval, delegate: AddItemController) {
    DateSelectionNavigator(navigationController: navigationController, servicePackage: servicePackage).setup(date: date, repeating: repeating, delegate: delegate)
  }
  func pop() {
    navigationController.popViewController(animated: true)
  }
}
