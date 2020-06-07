//
//  ItemsShowTypes.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

enum ItemsShowTypes: Int {
  case all, favorites, today, listNames
}
extension ItemsShowTypes {
  func text() -> String {
    switch self {
    case .all:
      return "all_item_show_type".localize()
    case .favorites:
      return "favorites_item_show_type".localize()
    case .today:
      return "today_item_show_type".localize()
    case .listNames:
      return "listNames_item_show_type".localize()
    }
  }
}
