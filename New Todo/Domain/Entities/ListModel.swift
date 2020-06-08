//
//  HomeModel.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

struct ListModel: Codable, Equatable {
  let iconColor: String
  let iconId: Int16
  let iconName: String
  let itemsCount: Int16
  var title: String
  let type: Int16
  
  func asDBList() -> List {
    let dbList = List(context: CoreDataStack.managedContext)
    dbList.id = UUID()
    dbList.iconColor = iconColor
    dbList.iconId = iconId
    dbList.iconName = iconName
    dbList.itemsCount = 0
    dbList.title = title
    dbList.createdAt = Date()
    dbList.type = type
    return dbList
  }
}
