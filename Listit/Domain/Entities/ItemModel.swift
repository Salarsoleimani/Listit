//
//  ItemModel.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-06.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import SwiftLocalNotification

struct ItemModelCodable: Codable, Equatable {
  let title: String
  let repeats: String?
  let description: String?
  let state: Int16?
  let listId: Int16
  var isFavorite: Bool?
  func toItemModel() -> ItemModel {
    let statee = ItemState(rawValue: state ?? 0) ?? ItemState.default
    return ItemModel(title: title, notifDate: nil, repeats: RepeatingInterval(rawValue: repeats ?? "none"), description: description, parentList: nil, state: statee, isFavorite: isFavorite)
  }
}
struct ItemModel {
  var title: String
  var notifDate: Date?
  var repeats: RepeatingInterval?
  let description: String?
  var parentList: List?
  let state: ItemState?
  var isFavorite: Bool?
  
  func asDBItem() -> Item {
    let dbItem = Item(context: CoreDataStack.managedContext)
    dbItem.id = UUID().uuidString
    dbItem.isFavorite = isFavorite ?? false
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
