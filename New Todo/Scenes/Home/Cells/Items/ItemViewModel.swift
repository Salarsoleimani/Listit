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
  init(model: Item) {
//    let titleString = NSAttributedString(string: model.title ?? "") { make in
//      make.font(Fonts.h4Regular)
//      make.color(Colors.title.value)
//    }
    self.title = model.title ?? ""
    self.model = model
  }
}
