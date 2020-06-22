//
//  ItemViewModel.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-06.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import SwiftLocalNotification

struct ItemViewModel {
  let model: Item
  let title: String
  let description: String
  let toDate: Date?
  let type: ListType
  let repeats: String
  let countdownTimeFormat: String
  
  let backgroundColor: UIColor
  let borderColor: UIColor
  let isFavoriteImage: UIImage
  let finishedLineImage: UIImage
  let finishedLineIsHidden: Bool
  var isShowingDetail: Bool
  
  init(model: Item) {
    self.model = model
    self.title = model.title ?? ""
    self.description = model.desc ?? ""
    let type = ListType(rawValue: model.list?.type ?? ListType.default.rawValue) ?? ListType.default
    self.type = type
    
    let now = Date()
    var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: model.notifDate ?? now)
    let currentYear = Calendar.current.component(.year, from: now)
    component.year = currentYear
    if let toDate = Calendar.current.date(from: component) {
      if toDate.timeIntervalSince(now) > 0 {
        component.year = currentYear
      } else {
        component.year = currentYear + 1
      }
    }
    
    self.toDate = Calendar.current.date(from: component)
    
    self.repeats = model.repeats ?? "Once"
    let intervals = RepeatingInterval(rawValue: model.repeats ?? "none") ?? RepeatingInterval.none
    
    switch intervals {
    case .none:
      self.countdownTimeFormat = "dd:hh:mm:ss"
    case .minute:
      self.countdownTimeFormat = "ss"
    case .hourly:
      self.countdownTimeFormat = "mm:ss"
    case .daily:
      self.countdownTimeFormat = "hh:mm:ss"
    case .weekly:
      self.countdownTimeFormat = "dd:hh:mm:ss"
    case .monthly:
      self.countdownTimeFormat = "dd:hh:mm:ss"
    case .yearly:
      self.countdownTimeFormat = "dd:hh:mm:ss"
    }
    
    self.backgroundColor = (UIColor(hexString: model.list?.iconColor ?? "") ?? Colors.main.value).withAlphaComponent(0.2)
    self.borderColor = (UIColor(hexString: model.list?.iconColor ?? "") ?? Colors.main.value).withAlphaComponent(0.5)
    self.isFavoriteImage = model.isFavorite ? UIImage(systemName: "star.fill")!.withTintColor(Colors.itemCellTitle.value, renderingMode: .alwaysTemplate) : UIImage(systemName: "star")!.withTintColor(Colors.itemCellTitle.value, renderingMode: .alwaysTemplate)
    let finishedLineRandomImage = [UIImage(named: "img_line1")!, UIImage(named: "img_line2")!].randomElement() ?? UIImage()
    self.finishedLineImage = finishedLineRandomImage
    self.finishedLineIsHidden = model.state == ItemState.done.rawValue ? false : true
    self.isShowingDetail = false
  }
}
