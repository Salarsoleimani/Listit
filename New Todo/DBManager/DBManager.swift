//
//  DBManager.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import CoreData

final public class DBManager: DatabaseManagerProtocol {
  //MARK: - Home Related Functions
  func get(Home home: HomeModel) {
    
  }
  //MARK: - Home Related Functions
  func add(List list: List, response: ((Bool) -> Void)?) {
    
  }
  
  func get(Lists response: @escaping ([List]) -> Void) {
    
  }
  
  func delete(List id: UUID, response: ((Bool) -> Void)?) {
    
  }
  
  func update(List list: List, response: ((Bool) -> Void)?) {
    
  }
  
  func add(Item item: List, items: [Item], response: ((Bool) -> Void)?) {
    
  }
  
  func get(ItemsForListUID: UUID, response: @escaping ([Item]) -> Void) {
    
  }
  
  func delete(Item id: UUID, response: ((Bool) -> Void)?) {
    
  }
  
  func update(Item item: Item, response: ((Bool) -> Void)?) {
    
  }
  //MARK: - Shared

  func resetFactory() {
    
  }
  
  
}