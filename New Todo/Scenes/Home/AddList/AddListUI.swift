//  
//  AddListUI.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

extension AddListController {
  func setupUI() {
    view.backgroundColor = Colors.background.value
    
    navigationItem.title = list == nil ? "add_list_navigation_title".localize() : "edit_list_navigation_title".localize()
    
    titleTextField.placeholder = "add_list_title_placeholder".localize()
    titleTextField.font = Fonts.listCellTitle
    titleTextField.textColor = Colors.listCellTitle.value
    titleTextField.tintColor = Colors.main.value
    
    containerView.backgroundColor = Colors.listCellBackground.value
    containerView.layer.cornerRadius = Constants.Radius.cornerRadius
    
    itemsQtyLabel.font = Fonts.listCellDescription
    itemsQtyLabel.textColor = Colors.listCellDescription.value
    
    iconButton.tintColor = Colors.white.value
    
    listTypeContainerView.backgroundColor = Colors.listCellBackground.value
    listTypeContainerView.layer.cornerRadius = Constants.Radius.cornerRadius
    
    listTypeTextField.placeholder = "select_list_type_placeholder".localize()
    listTypeTextField.font = Fonts.h5Regular
    listTypeTextField.textColor = Colors.listCellTitle.value
    
    listTypeTitleLabel.text = "list_type_title".localize()
    listTypeTitleLabel.font = Fonts.h5Bold
    listTypeTitleLabel.textColor = Colors.listCellTitle.value

    saveButton.makeNewTodoButton(title: "save_button_title".localize())
    if let list = list {
      iconContainerView.backgroundColor = UIColor(hexString: list.iconColor ?? "#FFFFFF") ?? .red

      let iconName = list.iconId > 0 ? "ic_\(list.iconId)" : list.iconName ?? "ic_error"
      let iconImage = UIImage(named: iconName) ?? UIImage(named: "ic_error")!
      
      
      iconButton.setImage(iconImage, for: .normal)
      
      titleTextField.text = list.title
      
      let type = ListType(rawValue: list.type) ?? ListType.default
      let itemsQuantity = list.itemsCount
      let quantityTitle = type.quantityTitle()
      let itemsCountText = itemsQuantity > 1 ? quantityTitle : quantityTitle.dropLast().description
      itemsQtyLabel.text = "\(itemsQuantity) \(itemsCountText)"
      
      listModel = ListModel(iconColor: list.iconColor ?? Constants.Defaults.color, iconId: list.iconId, iconName: "ic_\(list.iconId)", itemsCount: list.itemsCount, title: list.title ?? "", type: list.type)
      
      listTypeTextField.text = type.title()

    }

  }
}
