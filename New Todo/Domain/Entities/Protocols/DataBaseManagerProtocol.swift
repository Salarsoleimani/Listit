//
//  DataBaseManagerProtocol.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

protocol DatabaseManagerProtocol {
  //MARK: - Configuration
  func configureDataBase()
  //MARK: - List Related Functions
  func add(List list: ListModel, response: ((Bool) -> Void)?) -> List
  func getAllLists(response: @escaping ([List]) -> Void)
  func delete(List list: List,  response: ((Bool) -> Void)?)
  func update(List list: List, response: ((Bool) -> Void)?)
  
  //MARK: - Item Related Functions
  func add(Item item: ItemModel, response: ((Bool) -> Void)?)
  func get(ItemsForListUID: UUID, response: @escaping ([Item]) -> Void)
  func getAllItems(response: @escaping ([Item]) -> Void)
  func delete(Item item: Item,  response: ((Bool) -> Void)?)
  func update(Item item: Item, response: ((Bool) -> Void)?)
  
  // Shared
  func resetFactory()
}



