//
//  ListTypes.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

enum ListType: Int16 {
  case todo = 6
  case birthday = 1
  case gerocery = 2
  case favorites = 3
  case all = 4
  case today = 5
  case none = 0
}
extension ListType {
  static let `default` = ListType.none
  func title() -> String {
    switch self {
    case .todo:
      return "todo_lists_type".localize()
    case .birthday:
      return "birthday_lists_type".localize()
    case .gerocery:
      return "gerocery_lists_type".localize()
    case .all:
      return "all_lists_type".localize()
    case .favorites:
      return "favorites_lists_type".localize()
    case .today:
      return "today_lists_type".localize()
    case .none:
      return "No type"
    }
  }
  func quantityTitle() -> String {
    switch self {
    case .todo:
      return "todo_lists_type_quantity".localize()
    case .birthday:
      return "birthday_lists_type_quantity".localize()
    case .gerocery:
      return "gerocery_lists_type_quantity".localize()
    case .all:
      return "all_lists_type_quantity".localize()
    case .favorites:
      return "favorites_lists_type_quantity".localize()
    case .today:
      return "today_lists_type_quantity".localize()
    case .none:
      return "none_lists_type_quantity"
    }
  }
}
