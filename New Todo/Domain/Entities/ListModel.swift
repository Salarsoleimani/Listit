//
//  HomeModel.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

struct ListModel: Codable {
  let iconColor: String
  let iconId: Int16
  let itemsCount: Int16
  let title: String
  let type: Int16
  
  func asDBList() -> List {
    let dbList = List(context: CoreDataStack.managedContext)
    dbList.id = UUID()
    dbList.iconColor = iconColor
    dbList.iconId = iconId
    dbList.itemsCount = 0
    dbList.title = title
    dbList.createdAt = Date()
    return dbList
  }
}
