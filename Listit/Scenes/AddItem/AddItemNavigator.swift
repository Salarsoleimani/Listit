////  
////  AddItemNavigator.swift
////  Listit
////
////  Created by Salar Soleimani on 2020-06-06.
////  Copyright © 2020 ssmobileapps.com All rights reserved.
////
//
//import Foundation
//import SwiftLocalNotification
//import Haptico
//
//final class AddItemNavigator: Navigator {
//  func setup(item: Item?, parentList: List?, lists: [List], allItemsList: List?, itemTitle: String = "") {
//    let vc = AddItemController(navigator: self, dbManager: servicePackage.dbManager)
//    vc.parentList = parentList
//    vc.itemTitle = itemTitle
//    vc.lists = lists
//    vc.item = item
//    vc.allItemsList = allItemsList
//    navigationController.pushViewController(vc, animated: true)
//  }
//  func toDateSelection(date: Date?, repeating: RepeatingInterval, delegate: AddItemController) {
//    Haptico.shared().generate(.light)
//    DateSelectionNavigator(navigationController: navigationController, servicePackage: servicePackage).setup(date: date, repeating: repeating, delegate: delegate)
//  }
//  func pop() {
//    navigationController.popViewController(animated: true)
//  }
//}
