//
//  HomeControllerUI.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

extension HomeController {
  func setupUI() {
    view.backgroundColor = Colors.background.value

    listsCollectionView.backgroundColor = .clear
    itemsTableView.backgroundColor = .clear

    navigationItem.title = "all_items_navigation_title".localize()
    
    addItemButton.backgroundColor = Colors.main.value
    addItemLabel.font = Fonts.listCellTitle
    addItemLabel.textColor = Colors.white.value
  }
}
