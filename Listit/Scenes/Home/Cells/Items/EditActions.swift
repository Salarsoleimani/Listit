//
//  EditActions.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-26.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import UIKit

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
  
  func image() -> UIImage {
    let name: String
    switch self {
    case .finished: name = "checkmark.circle"
    case .unfinished: name = "arrow.uturn.left.circle"
    case .edit: name = "flag.fill"
    case .delete: name = "trash.fill"
      case .important: name = "star.fill"
      case .notImportant: name = "star.slash.fill"
    }
    let config = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .regular)
    let image = UIImage(systemName: name, withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysTemplate)
    return circularIcon(with: color(), size: CGSize(width: 30, height: 30), icon: image) ?? UIImage()
  }
  
  func color() -> UIColor {
    switch self {
    case .finished, .unfinished: return Colors.main.value
    case .important, .notImportant: return Colors.red.value
    case .edit:
      return #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
    case .delete: return #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
    }
  }
  
  func circularIcon(with color: UIColor, size: CGSize, icon: UIImage? = nil) -> UIImage? {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    
    UIBezierPath(ovalIn: rect).addClip()
    
    color.setFill()
    UIRectFill(rect)
    
    if let icon = icon {
      let iconRect = CGRect(x: (rect.size.width - icon.size.width) / 2,
                            y: (rect.size.height - icon.size.height) / 2,
                            width: icon.size.width,
                            height: icon.size.height)
      icon.draw(in: iconRect, blendMode: .normal, alpha: 1.0)
    }
    
    defer { UIGraphicsEndImageContext() }
    
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}
