//
//  HomeControllerDelegate.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-24.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

protocol HomeControllerDelegate: class {
  func listAdded(_ list: List)
}

extension HomeController: HomeControllerDelegate {
  func listAdded(_ list: List) {
    if let lists = listsDataSource.frc.fetchedObjects, lists.count - 1 > 0 {
      let row = lists.count - 1
      let index = IndexPath(item: row, section: 0)
      selectedList = lists[row]
      listsCollectionView.selectItem(at: index, animated: true, scrollPosition: .left)
    }
  }
}
