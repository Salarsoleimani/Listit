//  
//  DateSelectionUI.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-15.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import UIKit

extension DateSelectionController {
  func setupUI() {
    view.backgroundColor = Colors.background.value
    
    closeButton.tintColor = Colors.main.value
    
    navigationTitleLabel.text = "pick_date_navigation_title".localize()
    navigationTitleLabel.font = Fonts.navigationLargeTitle
    navigationTitleLabel.textColor = Colors.listCellTitle.value
    
    descriptionLabel.text = "pick_date_description".localize()
    descriptionLabel.font = Fonts.listCellDescription
    descriptionLabel.textColor = Colors.listCellDescription.value
    
    repeatsTitleLabel.text = "repeating_title".localize()
    repeatsTitleLabel.font = Fonts.h5Bold
    repeatsTitleLabel.textColor = Colors.listCellTitle.value
    
    repeatsContainerView.backgroundColor = Colors.listCellBackground.value
    repeatsContainerView.layer.cornerRadius = Constants.Radius.cornerRadius
    
    repeatsSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: Fonts.h6Regular], for: .normal)
    repeatsSegmentedControl.selectedSegmentTintColor = Colors.main.value
    
    dateTextField.font = Fonts.itemCellDescription
    dateTextField.text = dateFormatter.string(from: date ?? Date())
    dateTextField.textColor = Colors.listCellTitle.value
    
    dateContainerView.backgroundColor = Colors.listCellBackground.value
    dateContainerView.layer.cornerRadius = Constants.Radius.cornerRadius
    
    dateTitleLabel.text = "date_title".localize()
    dateTitleLabel.font = Fonts.h5Bold
    dateTitleLabel.textColor = Colors.listCellTitle.value
    
    timeTextField.font = Fonts.itemCellDescription
    timeTextField.text = timeFormatter.string(from: date ?? Date())
    timeTextField.textColor = Colors.listCellTitle.value
    
    timeTitleLabel.text = "time_title".localize()
    timeTitleLabel.font = Fonts.h5Bold
    timeTitleLabel.textColor = Colors.listCellTitle.value
    
    saveButton.makeListitButton(title: "save_button_title".localize())
    
    deleteButton.titleLabel?.font = Fonts.h5Regular
    deleteButton.tintColor = Colors.error.value
    deleteButton.setTitle("delete_reminder_button_title".localize(), for: .normal)
    
  }
}
