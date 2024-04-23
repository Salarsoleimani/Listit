//
//  HomeNavigator.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import Foundation
import Haptico
import SwiftUI

final class HomeNavigator: Navigator {
  func setup() {
    let homeVC = UIHostingController(rootView: HomeView(viewModel: HomeViewModel(navigator: self)))

    navigationController.pushViewController(homeVC, animated: true)
    navigationController.viewControllers = [homeVC]
  }
  
//  func toAddOrEditList(list: List?, delegate: HomeControllerDelegate) {
//    Haptico.shared().generate(.light)
//    AddListNavigator(navigationController: navigationController, servicePackage: servicePackage).setup(list: list, delegate: delegate)
//  }
  
//  func toAddOrEditItem(item: Item?, forList: List?, lists: [List], allItemsList: List?, itemTitle: String = "") {
//    Haptico.shared().generate(.light)
//    AddItemNavigator(navigationController: navigationController, servicePackage: servicePackage).setup(item: item, parentList: forList, lists: lists, allItemsList: allItemsList, itemTitle: itemTitle)
//  }
}
