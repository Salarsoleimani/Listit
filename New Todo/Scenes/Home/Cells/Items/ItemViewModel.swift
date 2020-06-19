//
//  ItemViewModel.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-06.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

struct ItemViewModel {
  let model: Item
  let title: String
  let description: String
  let toDate: Date?
  let type: ListType
  let repeats: String
  let backgroundColor: UIColor
  let borderColor: UIColor
  let isFavoriteImage: UIImage
  
  init(model: Item) {
    self.model = model
    self.title = model.title ?? ""
    self.description = model.desc ?? ""
    let type = ListType(rawValue: model.list?.type ?? ListType.default.rawValue) ?? ListType.default
    self.type = type
    self.toDate = model.notifDate
    self.repeats = model.repeats ?? "No repeat"
    self.backgroundColor = (UIColor(hexString: model.list?.iconColor ?? "") ?? Colors.main.value).withAlphaComponent(0.5)
    self.borderColor = (UIColor(hexString: model.list?.iconColor ?? "") ?? Colors.main.value).withAlphaComponent(0.8)
    self.isFavoriteImage = model.isFavorite ? UIImage(systemName: "star.fill")!.withTintColor(Colors.itemCellTitle.value, renderingMode: .alwaysTemplate) : UIImage(systemName: "star")!.withTintColor(Colors.itemCellTitle.value, renderingMode: .alwaysTemplate)
  }
}
