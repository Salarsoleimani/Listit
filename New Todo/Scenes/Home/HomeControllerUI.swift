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
    
    addItemButton.makeNewTodoButton(title: "")
    addItemLabel.font = Fonts.listCellTitle
    addItemLabel.textColor = Colors.white.value
    addItemLabel.text = "add_item_button_title".localize()
    
    addListButton.makeNewTodoButton(title: "")
    addListLabel.font = Fonts.listCellTitle
    addListLabel.textColor = Colors.white.value
    addListLabel.text = "add_list_button_title".localize()
  }
}
