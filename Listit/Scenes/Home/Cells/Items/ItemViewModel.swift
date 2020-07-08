//
//  ItemViewModel.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-06.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import UIKit
import SwiftLocalNotification

struct ItemViewModel {
  let model: Item
  let title: String
  let description: String
  let toDate: Date?
  let type: ListType
  let countdownTimeFormat: String
  
  let repeats: String
  let dueDate: String
  let haveDate: Bool

  let backgroundColor: UIColor
  let borderColor: UIColor
  let isFavoriteHidden: Bool
  let finishedLineImage: UIImage
  var finishedLineIsHidden: Bool
  var isShowingDetail: Bool
  init(model: Item) {
    self.model = model
    self.title = model.title ?? ""
    self.description = model.desc ?? ""
    let type = model.list?.getListType() ?? .default
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
    
    if let repeats = model.repeats {
      if repeats == "none" {
        self.repeats = "once"
      } else {
        self.repeats = repeats
      }
    } else {
      self.repeats = "doesnt_set_repeats_title".localize()
    }
    let intervals = RepeatingInterval(rawValue: model.repeats ?? "none") ?? RepeatingInterval.none
    let dateFormatter = DateFormatter()
    switch intervals {
    case .none:
      dateFormatter.dateFormat = "YYYY/MMM/dd HH:mm"
      self.countdownTimeFormat = "dd:hh:mm:ss"
    case .minute:
      self.countdownTimeFormat = "ss"
    case .hourly:
      dateFormatter.dateFormat = "HH:mm"
      self.countdownTimeFormat = "mm:ss"
    case .daily:
      dateFormatter.dateFormat = "HH:mm"
      self.countdownTimeFormat = "hh:mm:ss"
    case .weekly:
      dateFormatter.dateFormat = "EEEE, HH:mm"
      self.countdownTimeFormat = "dd:hh:mm:ss"
    case .monthly:
      dateFormatter.dateFormat = "d,HH:mm"
      self.countdownTimeFormat = "dd:hh:mm:ss"
    case .yearly:
      dateFormatter.dateFormat = "MMM dd, HH:mm"
      self.countdownTimeFormat = "dd:hh:mm:ss"
    }
    if let notifDate = model.notifDate {
      var dateStr = dateFormatter.string(from: notifDate)
      if intervals == .monthly {
        let dateAndTime = dateStr.components(separatedBy: ",")
        if dateAndTime.count == 2 {
          let day = dateAndTime[0]
          let time = dateAndTime[1]
          let dayTitle = "day_title".localize()
          let ofMonthTitle = "of_month_title".localize()
          if day == "1" {
            dateStr = "\(day)st \(dayTitle) \(ofMonthTitle), \(time)"
          } else if day == "2" {
            dateStr = "\(day)nd \(dayTitle) \(ofMonthTitle), \(time)"
          } else {
            dateStr = "\(day)th \(dayTitle) \(ofMonthTitle), \(time)"
          }
        }
      }
      self.dueDate = dateStr
      self.haveDate = true
    } else {
      self.dueDate = "doesnt_set_date_title".localize()
      self.haveDate = false
    }
    
    self.backgroundColor = UIColor(hexString: model.list?.iconColor ?? "") .withAlphaComponent(0.4)
    self.borderColor = UIColor(hexString: model.list?.iconColor ?? "")
    self.isFavoriteHidden = !model.isFavorite
    let finishedLineRandomImage = [UIImage(named: "img_line1")!, UIImage(named: "img_line2")!].randomElement() ?? UIImage()
    self.finishedLineImage = finishedLineRandomImage
    self.finishedLineIsHidden = model.state == ItemState.done.rawValue ? false : true
    self.isShowingDetail = false
  }
}
