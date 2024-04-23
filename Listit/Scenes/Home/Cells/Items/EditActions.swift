//
//  EditActions.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-26.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import UIKit
import SwiftUI

enum ActionDescriptor {
  case finished, unfinished, edit, delete, important, notImportant
  
  func title() -> String {
    switch self {
    case .finished: return "mark_as_completed_item_title".localize()
    case .unfinished: return "uncomplete_item_title".localize()
    case .edit: return "edit_list_action".localize()
    case .delete: return "delete_list_action".localize()
    case .important: return "favorite_item_title".localize()
    case .notImportant: return "unfavorite_item_title".localize()
    }
  }
  
  func image() -> some View {
    let name: String
    switch self {
    case .finished: name = "checkmark.circle"
    case .unfinished: name = "arrow.uturn.left.circle"
    case .edit: name = "flag.fill"
    case .delete: name = "trash.fill"
      case .important: name = "star.fill"
      case .notImportant: name = "star.slash.fill"
    }
    
    return Image(systemName: name)
      .resizable()
      .frame(width: 30, height: 30)

  }
  
  func color() -> Color {
    switch self {
    case .finished, .unfinished: return Colors.main.value
    case .important, .notImportant: return Colors.red.value
    case .edit: return Colors.custom(hex: 0xC7C6CB, alpha: 1).value
    case .delete: return Colors.error.value
    }
  }
  
}
