//  
//  AddListUI.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import UIKit

extension AddListController {
  func setupLocalization() {
    navigationItem.title = list == nil ? "add_list_navigation_title".localize() : "edit_list_navigation_title".localize()
    
    titleTextField.placeholder = "add_list_title_placeholder".localize()

    listTypeTitleLabel.text = "list_type_title".localize()

    listTypeSegmentedControl.setTitle("reminder_lists_type".localize(), forSegmentAt: 0)
    listTypeSegmentedControl.setTitle("note_lists_type".localize(), forSegmentAt: 1)
    listTypeSegmentedControl.setTitle("countdown_lists_type".localize(), forSegmentAt: 2)

    if list != nil {
      saveButton.makeNewTodoButton(title: "update_button_title".localize())
    } else {
      saveButton.makeNewTodoButton(title: "save_button_title".localize())
    }
  }
  func setupUI() {
    view.backgroundColor = Colors.background.value
    
    titleTextField.font = Fonts.listCellTitle
    titleTextField.textColor = Colors.listCellTitle.value
    titleTextField.tintColor = Colors.main.value
    
    containerView.backgroundColor = Colors.listCellBackground.value
    containerView.layer.cornerRadius = Constants.Radius.cornerRadius
    
    iconButton.tintColor = Colors.white.value
    
    listTypeContainerView.backgroundColor = Colors.listCellBackground.value
    listTypeContainerView.layer.cornerRadius = Constants.Radius.cornerRadius
    
    listTypeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: Fonts.h5Regular], for: .normal)
    listTypeSegmentedControl.selectedSegmentTintColor = Colors.main.value
        
    listTypeTitleLabel.font = Fonts.h5Bold
    listTypeTitleLabel.textColor = Colors.listCellTitle.value

    editIconLabel.text = "edit_button_title".localize()
    editIconLabel.font = Fonts.h6Bold
    editIconLabel.textColor = Colors.main.value
    editIconLabel.backgroundColor = Colors.listCellBackground.value.withAlphaComponent(0.6)
    
    if let list = list {
      iconContainerView.backgroundColor = UIColor(hexString: list.iconColor ?? "#FFFFFF") 

      let iconName = list.iconId > 0 ? "ic_\(list.iconId)" : list.iconName ?? "ic_error"
      let iconImage = UIImage(named: iconName) ?? UIImage(named: "ic_error")!
      
      
      iconButton.setImage(iconImage, for: .normal)
      
      titleTextField.text = list.title
      
      let type = list.getListType()
      
      listModel = ListModel(iconColor: list.iconColor ?? Constants.Defaults.color, iconId: list.iconId, iconName: "ic_\(list.iconId)", itemsCount: list.itemsCount, title: list.title ?? "", type: list.type)
      
      if type.rawValue - 1 > 0 {
        listTypeSegmentedControl.selectedSegmentIndex = Int(type.rawValue - 1)
      }
    }
    iconContainerView.clipsToBounds = true
  }
}
