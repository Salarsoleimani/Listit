//
//  AddListDelegates.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-07-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

protocol AddListControllerDelegate {
  func iconSelected(_ icon: IconCellViewModel)
}
extension AddListController: AddListControllerDelegate {
  func iconSelected(_ icon: IconCellViewModel) {
    listModel.iconName = "ic_\(icon.model.id)"
    listModel.iconId = Int16(icon.model.id)
    listModel.iconColor = icon.colorModel.value
    
    iconButton.setTitle("", for: .normal)
    iconButton.setImage(icon.image, for: .normal)
    iconContainerView.backgroundColor = icon.color
  }
}
