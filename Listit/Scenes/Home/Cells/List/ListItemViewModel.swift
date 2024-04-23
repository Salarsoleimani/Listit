//
//  ListNameItemViewModel.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import UIKit

struct ListItemViewModel {
  let model: List
  let title: String
  let iconColor: UIColor
  let iconImage: UIImage
  let itemsCount: String
  let type: ListType
  init(model: List) {
    self.model = model
    
    self.title = model.title ?? ""
    
    let type = model.getListType()
    self.type = type
    
    let itemsQuantity = model.itemsCount
    let quantityTitle = type.quantityTitle()
    let itemsCountText = itemsQuantity > 1 ? quantityTitle : quantityTitle.dropLast().description
    self.itemsCount = "\(itemsQuantity) \(itemsCountText)"
    
    let defaultIcon = UIImage(named: "ic_error")!
    self.iconImage = model.iconId != -1 ? (UIImage(named: "ic_\(model.iconId)") ?? defaultIcon) : UIImage(named: model.iconName ?? "ic_error") ?? defaultIcon
    self.iconColor = UIColor(hexString: model.iconColor ?? "#FFFFFF")
  }
}
