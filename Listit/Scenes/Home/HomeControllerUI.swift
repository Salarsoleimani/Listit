//
//  HomeControllerUI.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

extension HomeController {
  func setLocalization() {
    addItemLabel.text = "add_item_button_title".localize()

    addListLabel.text = "add_list_button_title".localize()

    titleItemTextField.placeholder = "add_item_title_placeholder".localize()
    
    addMoreDetailForItemButton.setTitle("add_more_detail_quick_item".localize(), for: .normal)

  }
  
  func setupUI() {
    navigationItem.title = "all_items_navigation_title".localize()

    view.backgroundColor = Colors.background.value

    listsCollectionView.backgroundColor = .clear
    itemsTableView.backgroundColor = .clear

    setupAddItemButton()
    
    addListButton.makeNewTodoButton(title: "")
    addListLabel.font = Fonts.listCellTitle
    addListLabel.textColor = Colors.white.value
    
    addMoreDetailForItemButton.titleLabel?.font = Fonts.h5Regular
    addMoreDetailForItemButton.tintColor = Colors.main.value
    
    titleItemTextField.tintColor = Colors.main.value
    titleItemTextField.font = Fonts.itemCellTitle
    titleItemTextField.textColor = Colors.itemCellTitle.value
    
    titleItemContainerView.backgroundColor = Colors.background.value
    
    noItemsLabel.font = Fonts.h5Regular
    noItemsLabel.textColor = Colors.itemCellTitle.value
  }
  func setupAddItemButton() {
    addItemButton.makeNewTodoButton(title: "")
    addItemLabel.font = Fonts.listCellTitle
    addItemLabel.textColor = Colors.white.value
    addItemLabel.text = "add_item_button_title".localize()
  }
  func registerCells() {
    let listNib = UINib(nibName: "ListCell", bundle: nil)
    listsCollectionView.register(listNib, forCellWithReuseIdentifier: Constants.CellIds.cellId)
    let itemNib = UINib(nibName: "ItemCell", bundle: nil)
    itemsTableView.register(itemNib, forCellReuseIdentifier: Constants.CellIds.cellId)
  }
}
