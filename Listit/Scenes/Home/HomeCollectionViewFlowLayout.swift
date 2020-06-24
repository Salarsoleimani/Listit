//
//  HomeCollectionViewFlowLayout.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-23.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

extension HomeController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == listsCollectionView {
      let listHeight = 150
      return CGSize(width: 150, height: listHeight)
    }
    let itemsCVWidth = itemsCollectionView.frame.width
    var height: CGFloat = 50
    let items = itemsDataSource.frc.fetchedObjects

    if selecteItemIndexpaths.contains(indexPath) {
      if let items = items, indexPath.row < items.count {
        let specificItem = items[indexPath.row]
        let itemListType = ListType(rawValue: specificItem.list?.type ?? ListType.default.rawValue) ?? ListType.default
        switch itemListType {
        case .reminder:
          height =  124
        case .note:
          height = 80
        case .countdown:
          height = 166
        default: break
        }
        if let desc = specificItem.desc, !desc.isEmpty {} else {height -= 22}
      }
      return CGSize(width: itemsCVWidth, height: height)
    }
    if let items = items, indexPath.row < items.count {
      let specificItem = items[indexPath.row]
      let itemListType = ListType(rawValue: specificItem.list?.type ?? ListType.default.rawValue) ?? ListType.default
      switch itemListType {
      case .reminder:
        height =  58
      case .note:
        height = 58
      case .countdown:
        height = 98
      default: break
      }
    }
    return CGSize(width: itemsCVWidth, height: height)

  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
  }
}
