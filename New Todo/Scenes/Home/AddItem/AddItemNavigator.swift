//  
//  AddItemNavigator.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-06.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

final class AddItemNavigator: Navigator {
  func setup(parentList: List?, lists: [List]) {
    let vc = AddItemController(navigator: self, dbManager: servicePackage.dbManager)
    vc.parentList = parentList
    vc.lists = lists
    navigationController.pushViewController(vc, animated: true)
  }
}
