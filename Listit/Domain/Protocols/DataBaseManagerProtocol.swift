//
//  DataBaseManagerProtocol.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import Foundation

protocol DatabaseManagerProtocol {
  //MARK: - Configuration
  func configureDataBase()
  //MARK: - List Related Functions
  func addList(_ list: ListModel, withHaptic: Bool, response: ((Bool) -> Void)?) -> List
  func delete(List list: List,  response: ((Bool) -> Void)?)
  func update(List list: List, response: ((Bool) -> Void)?)
  
  //MARK: - Item Related Functions
  func addItem(_ item: ItemModel, allItemsList: List?, withHaptic: Bool, response: ((Bool) -> Void)?)
  func delete(Item item: Item, allItemsList: List?, favoriteList: List?, response: ((Bool) -> Void)?)
  func update(Item item: Item, isNotifDateChanged: Bool, response: ((Bool) -> Void)?)
  func updateIsFavorite(isFavorite: Bool, favoriteList: List?, item: Item)
  func updateState(item: Item, state: ItemState)
  // Shared
  func resetFactory()
}



