//
//  ListTypes.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

enum ListType: Int16 {
  case none = 0
  
  case reminder = 1
  case note = 2
  case countdown = 3
  case habit = 4
  //case media = 5
  
  case favorites = 98
  //case today = 99
  case all = 100
}

extension ListType {
  static let `default` = ListType.none
  func title() -> String {
    switch self {
    case .none:
      return "No type"
      
    case .reminder:
      return "reminder_lists_type".localize()
    case .note:
      return "note_lists_type".localize()
    case .countdown:
      return "countdown_lists_type".localize()
    case .habit:
      return "habits_lists_type".localize()
      
    case .all:
      return "all_lists_type".localize()
    case .favorites:
      return "favorites_lists_type".localize()
    
    }
  }
  func quantityTitle() -> String {
    switch self {
    case .none:
      return "none_lists_type_quantity"
      
    case .reminder:
      return "reminder_lists_type_quantity".localize()
    case .countdown:
      return "countdown_lists_type_quantity".localize()
    case .note:
      return "note_lists_type_quantity".localize()
    case .habit:
      return "habit_lists_type_quantity".localize()
      
    case .all:
      return "all_lists_type_quantity".localize()
    case .favorites:
      return "favorites_lists_type_quantity".localize()
      
    
    }
  }
}
