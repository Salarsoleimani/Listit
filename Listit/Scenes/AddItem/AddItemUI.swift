////  
////  AddItemUI.swift
////  Listit
////
////  Created by Salar Soleimani on 2020-06-06.
////  Copyright © 2020 ssmobileapps.com All rights reserved.
////
//
//import UIKit
//import SwiftLocalNotification
//
//extension AddItemController {
//  func setupLocalization() {
//    navigationItem.title = item == nil ? "add_item_navigation_title".localize() : "edit_item_navigation_title".localize()
//    
//    if let parentList = parentList, let title = parentList.title {
//      descriptionLabel?.text = String(format: "add_item_description".localize(), title)
//    } else {
//      descriptionLabel?.text = String(format: "add_item_description".localize(), "")
//    }
//    
//    titleTextField.placeholder = "add_item_title_placeholder".localize()
//    
//    moreInfoButton.setTitle("more_info_about_item_title".localize(), for: .normal)
//    
//    remindMeButton.setTitle("remind_me_button_title".localize(), for: .normal)
//    
//    remindMeTitleLabel.text = "remind_me_title".localize()
//    
//    whichListTitleLabel.text = "which_list_title".localize()
//    
//    if let parentList = parentList {
//      let type = parentList.getListType()
//      if type != .all && type != .favorites {
//        whichListTextField.text = parentList.title
//      } else {
//        whichListTextField.text = "select_list_placeholder".localize()
//      }
//    }
//    if item != nil {
//      if let interval = repeats, let notifDate = notifDate {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYYY/MMM/dd HH:mm"
//        let dateStr = formatter.string(from: notifDate)
//        let title = interval != .none ? "\(dateStr) (\(interval.rawValue))": dateStr
//        remindMeButton.setTitle(title, for: .normal)
//      }
//      saveButton.makeListitButton(title: "update_button_title".localize())
//      saveAndAddAnotherButton.makeListitButton(title: "update_and_another_item_button_title".localize())
//      whichListTextField.placeholder = "select_into_which_list_placeholder".localize()
//    } else {
//      saveButton.makeListitButton(title: "save_button_title".localize())
//      saveAndAddAnotherButton.makeListitButton(title: "save_and_another_item_button_title".localize())
//      whichListTextField.placeholder = "select_list_placeholder".localize()
//      
//    }
//  }
//  func setupUI() {
//    view.backgroundColor = Colors.background.value
//    
//    descriptionLabel?.textColor = Colors.listCellDescription.value
//    descriptionLabel?.font = Fonts.h5Regular
//    
//    titleTextField.font = Fonts.itemCellTitle
//    titleTextField.textColor = Colors.itemCellTitle.value
//    titleTextField.tintColor = Colors.main.value
//    
//    moreInfoButton.tintColor = Colors.main.value
//    moreInfoButton.titleLabel?.font = Fonts.h5Regular
//    
//    moreInfoTextView.font = Fonts.itemCellDescription
//    moreInfoTextView.textColor = Colors.itemCellDescription.value
//    moreInfoTextView.tintColor = Colors.main.value
//    moreInfoTextView.layer.cornerRadius = Constants.Radius.textViewCornerRadius
//    
//    titleContainerView.backgroundColor = Colors.listCellBackground.value
//    titleContainerView.layer.cornerRadius = Constants.Radius.cornerRadius
//    
//    remindMeContainerView?.backgroundColor = Colors.listCellBackground.value
//    remindMeContainerView?.layer.cornerRadius = Constants.Radius.cornerRadius
//    
//    remindMeButton.titleLabel?.font = Fonts.h5Regular
//    remindMeButton.tintColor = Colors.main.value
//    
//    remindMeTitleLabel.font = Fonts.h5Bold
//    remindMeTitleLabel.textColor = Colors.listCellTitle.value
//    
//    whichListContainerView.backgroundColor = Colors.listCellBackground.value
//    whichListContainerView.layer.cornerRadius = Constants.Radius.cornerRadius
//    
//    whichListTitleLabel.font = Fonts.h5Bold
//    whichListTitleLabel.textColor = Colors.listCellTitle.value
//    
//    
//    whichListTextField.font = Fonts.h5Regular
//    whichListTextField.textColor = Colors.listCellTitle.value
//    
//    rightArrowImageView.tintColor = Colors.listCellTitle.value
//      
//    saveAndAddAnotherButton.titleLabel?.adjustsFontSizeToFitWidth = true
//    
//    titleTextField.text = itemTitle
//    if let item = item {
//      parentList = item.list
//      
//      titleTextField.text = item.title
//      if let desc = item.desc, !desc.isEmpty {
//        moreInfoTextView.text = desc
//        moreInfoTextView?.isHidden = false
//        moreInfoButton.isHidden = true
//      } else {
//        moreInfoButton.isHidden = false
//        moreInfoTextView.isHidden = true
//      }
//      
//      notifDate = item.notifDate
//      if let rep = item.repeats, let interval = RepeatingInterval(rawValue: rep) {
//        if let notifDate = notifDate {
//          let formatter = DateFormatter()
//          formatter.dateFormat = "YYYY/MMM/dd HH:mm"
//          let dateStr = formatter.string(from: notifDate)
//          let title = interval != .none ? "\(dateStr) (\(interval.rawValue))": dateStr
//          remindMeButton.setTitle(title, for: .normal)
//        }
//        repeats = interval
//      }
//      whichListTextField.text = item.list?.title
//      
//    }
//  }
//}
