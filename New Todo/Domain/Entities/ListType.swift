//
//  ListTypes.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

enum ListType: Int16 {
  case todo, birthday, gerocery, none
}
extension ListType {
  static let `default` = ListType.none
  func text() -> String {
    switch self {
    case .todo:
      return "tasks"
    case .birthday:
      return "birthdays"
    case .gerocery:
      return "items"
    case .none:
      return "items"
    }
  }
}
