////  
////  AddListNavigator.swift
////  Listit
////
////  Created by Salar Soleimani on 2020-06-03.
////  Copyright © 2020 ssmobileapps.com All rights reserved.
////
//
//import Foundation
//import Haptico
//
//final class AddListNavigator: Navigator {
//  func setup(list: List?, delegate: HomeControllerDelegate) {
//    let vc = AddListController(navigator: self, dbManager: servicePackage.dbManager)
//    vc.list = list
//    vc.delegate = delegate
//    navigationController.pushViewController(vc, animated: true)
//  }
//  func toIconSelector(delegate: AddListControllerDelegate, listTitle: String) {
//    Haptico.shared().generate(.light)
//    IconsNavigator(navigationController: navigationController, servicePackage: servicePackage).setup(delegate: delegate, listTitle: listTitle)
//  }
//  func pop() {
//    navigationController.popViewController(animated: true)
//  }
//}
