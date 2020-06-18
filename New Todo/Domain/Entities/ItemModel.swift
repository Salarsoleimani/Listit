//
//  ItemModel.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-06.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import SwiftLocalNotification

struct ItemModel {
  let title: String
  let notifDate: Date?
  let repeats: RepeatingInterval?
  let description: String?
  let parentList: List
  
  func asDBItem() -> Item {
    let dbItem = Item(context: CoreDataStack.managedContext)
    dbItem.id = UUID()
    dbItem.title = title
    dbItem.createdAt = Date()
    dbItem.list = parentList
    dbItem.desc = description
    dbItem.notifDate = notifDate
    dbItem.repeats = repeats?.rawValue
    return dbItem
  }
}
