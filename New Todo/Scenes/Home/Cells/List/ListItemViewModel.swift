//
//  ListNameItemViewModel.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
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
//    let titleString = NSAttributedString(string: model.title ?? "") { make in
//      make.font(Fonts.h4Regular)
//      make.color(Colors.title.value)
//    }
    self.title = model.title ?? ""
    self.model = model
    let type = ListType(rawValue: model.type) ?? ListType.default
    self.type = type
    let itemsQuantity = model.itemsCount
    let itemsCountText = itemsQuantity > 1 ? type.text() : type.text()
    self.itemsCount = "\(itemsQuantity) \(itemsCountText)"
    self.iconImage = UIImage(named: "ic_\(model.iconId)") ?? UIImage(named: "ic_error")!
    self.iconColor = UIColor(hexString: model.iconColor ?? "#FFFFFF") ?? .red
  }
}
