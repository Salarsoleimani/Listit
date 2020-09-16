//
//  HomeControllerUI.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import UIKit

extension HomeController {
  func setLocalization() {
    addListLabel.text = "add_list_button_title".localize()

    titleItemTextField.placeholder = "add_item_title_placeholder".localize()
    
    addMoreDetailForItemButton.setTitle("add_more_detail_quick_item".localize(), for: .normal)
    saveAndAddAnotherItemButton.setTitle("save_and_another_item_button_title".localize(), for: .normal)
  }
  func setupConfiguration() {
    setupNavigationButtons()
    registerCells()
  }
  func setupUI() {
    let mainColor = Colors.main.value
    navigationItem.title = "all_items_navigation_title".localize()

    view.backgroundColor = Colors.background.value

    listsCollectionView.backgroundColor = .clear
    itemsTableView.backgroundColor = .clear

    autoLayoutAddItemButtonUI(.all)
    
    addListButton.makeListitButton(title: "")
    addListLabel.font = Fonts.listCellTitle
    addListLabel.textColor = Colors.white.value
    
    backToFirstButton.backgroundColor = Colors.main.value
    backToFirstButton.layer.cornerRadius = Constants.Radius.cornerRadius
    backToFirstButton.tintColor = Colors.white.value
    
    addMoreDetailForItemButton.titleLabel?.font = Fonts.h5Regular
    addMoreDetailForItemButton.tintColor = mainColor
    addMoreDetailForItemButton.setTitleColor(mainColor, for: .normal)
    
    saveAndAddAnotherItemButton.titleLabel?.font = Fonts.h5Bold
    saveAndAddAnotherItemButton.tintColor = Colors.white.value
    saveAndAddAnotherItemButton.backgroundColor = mainColor
    saveAndAddAnotherItemButton.layer.cornerRadius = Constants.Radius.cornerRadius
    
    titleItemTextField.tintColor = mainColor
    titleItemTextField.font = Fonts.itemCellTitle
    titleItemTextField.textColor = Colors.itemCellTitle.value
    
    titleItemContainerView.backgroundColor = Colors.secondBackground.value
    
    noItemsLabel.font = Fonts.h5Regular
    noItemsLabel.textColor = Colors.itemCellTitle.value
    
    closeQiuckItemButton.tintColor = mainColor
  }
  
  internal func autoLayoutAddItemButtonUI(_ type: ListType) {
    addItemButton.makeListitButton(title: "")
    addItemLabel.font = Fonts.listCellTitle
    addItemLabel.textColor = Colors.white.value
    
    if type == .all || type == .favorites {
      addItemButton.backgroundColor = Colors.main.value
      addItemLabel.text = "add_item_button_title".localize()
      addItemButton.tag = 0
      return
    }
    addItemButton.backgroundColor = Colors.second.value
    addItemLabel.text = "quick_add_item_button_title".localize()
    addItemButton.tag = 1
  }
  
  private func setupNavigationButtons() {
    let rightBarButton = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(settingButtonPressed))
    navigationItem.rightBarButtonItems = [rightBarButton]
  }
  @objc private func settingButtonPressed() {
    navigator.toSetting()
  }
  private func registerCells() {
    let listNib = UINib(nibName: "ListCell", bundle: nil)
    listsCollectionView.register(listNib, forCellWithReuseIdentifier: Constants.CellIds.cellId)
    let itemNib = UINib(nibName: "ItemCell", bundle: nil)
    itemsTableView.register(itemNib, forCellReuseIdentifier: Constants.CellIds.cellId)
  }
}
