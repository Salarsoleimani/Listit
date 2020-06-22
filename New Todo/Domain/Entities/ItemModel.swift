//
//  ItemModel.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-06.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import SwiftLocalNotification
struct ItemModelCodable: Codable, Equatable {
  let title: String
  let repeats: String?
  let description: String?
  let state: ItemState?

  func toItemModel() -> ItemModel {
    return ItemModel(title: title, notifDate: nil, repeats: RepeatingInterval(rawValue: repeats ?? "none"), description: description, parentList: nil, state: state)
  }
}
struct ItemModel {
  var title: String
  var notifDate: Date?
  let repeats: RepeatingInterval?
  let description: String?
  var parentList: List?
  let state: ItemState?
  
  func asDBItem() -> Item {
    let dbItem = Item(context: CoreDataStack.managedContext)
    dbItem.id = UUID().uuidString
    dbItem.title = title
    dbItem.createdAt = Date()
    dbItem.list = parentList
    dbItem.desc = description
    dbItem.notifDate = notifDate
    dbItem.repeats = repeats?.rawValue
    dbItem.state = state?.rawValue ?? ItemState.default.rawValue
    return dbItem
  }
}
