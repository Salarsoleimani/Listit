//
//  DBManager.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import CoreData

final public class DBManager: DatabaseManagerProtocol {
  //MARK: - Configuration
  func configureDataBase() {
    if Defaults.appOpenedCount == 0 || !Defaults.isDatabaseConfigured {
      let templateLists = SSMocker<ListModel>.loadGenericObjectsFromLocalJson(fileName: "TemplateLists")
      for templateList in templateLists {
        var list = templateList
        list.title = templateList.title.localize()
        _ = add(List: list, response: nil)
        if let last = templateLists.last, templateList == last {
          Defaults.isDatabaseConfigured = true
        }
      }
    }
  }
  //MARK: - List Related Functions
  func add(List list: ListModel, response: ((Bool) -> Void)?) -> List {
    let dbList = list.asDBList()
    CoreDataStack.shared.saveContext()
    return dbList
  }
  
  func getAllLists(response: @escaping ([List]) -> Void) {
    let fetch = NSFetchRequest<List>(entityName: "List")
    fetch.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]

    do {
      response(try CoreDataStack.managedContext.fetch(fetch))
    } catch {
      print("Error fetching lists")
    }
  }
  func delete(List list: List, response: ((Bool) -> Void)?) {
    CoreDataStack.managedContext.delete(list)
    CoreDataStack.shared.saveContext()
  }
  
  func update(List list: List, response: ((Bool) -> Void)?) {
    CoreDataStack.shared.saveContext()
  }
  //MARK: - Item Related Functions
  func add(Item item: ItemModel, response: ((Bool) -> Void)?) {
    let _ = item.asDBItem()
    CoreDataStack.shared.saveContext()
  }
  
  func get(ItemsForListUID: UUID, response: @escaping ([Item]) -> Void) {
    
  }
  func getAllItems(response: @escaping ([Item]) -> Void) {
    let fetch = NSFetchRequest<Item>(entityName: "Item")
    fetch.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]

    do {
      response(try CoreDataStack.managedContext.fetch(fetch))
    } catch {
      print("Error fetching lists")
    }
  }
  func delete(Item item: Item, response: ((Bool) -> Void)?) {
    
  }
  
  func update(Item item: Item, response: ((Bool) -> Void)?) {
    
  }
  //MARK: - Shared
  
  func resetFactory() {
    
  }
  
  
}
