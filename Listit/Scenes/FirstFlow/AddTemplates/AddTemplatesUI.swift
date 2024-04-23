////  
////  AddTemplatesUI.swift
////  Listit
////
////  Created by Salar Soleimani on 2020-08-09.
////  Copyright © 2020 SaSApps. All rights reserved.
////
//
//import UIKit
//
//extension AddTemplatesController {
//  func setupUI() {
//    view.backgroundColor = Colors.background.value
//    
//    descriptionLabel.textColor = Colors.listCellDescription.value
//    descriptionLabel.font = Fonts.h3Regular
//    
//    [motivationButton, birthdaysButton, geroceriesButton].forEach { (button) in
//      button?.titleLabel?.font = Fonts.itemCellTitle
//      button?.titleLabel?.textColor = Colors.listCellTitle.value
//      button?.tintColor = Colors.main.value
//    }
//    closeButton.tintColor = Colors.main.value
//  }
//  func setLocalization() {
//    navigationItem.title = "add_template_navigation_title".localize()
//    
//    descriptionLabel.text = "add_template_description".localize()
//    
//    motivationButton.setTitle("template_motivations_list".localize(), for: .normal)
//    birthdaysButton.setTitle("template_birthdays_list".localize(), for: .normal)
//    geroceriesButton.setTitle("template_geroceries_list".localize(), for: .normal)
//    
//    letsGoButton.makeListitButton(title: "lets_go_button".localize())
//
//  }
//}
