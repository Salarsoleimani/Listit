//
//  DBManager.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import CoreData
import CloudKit
import SwiftLocalNotification

final public class DBManager: DatabaseManagerProtocol {
  //MARK: - Configuration
  func configureDataBase() {
    if !Defaults.isDatabaseConfigured {
      CKContainer.default().fetchUserRecordID { (id, err) in
        if let error = err as NSError? {
          print("errrrrrrr\(error.code)")
        } else {
          print("idddd: \(String(describing: id))")
        }
      }
      let query = CKQuery(recordType: "CD_List", predicate: NSPredicate(value: true))
      CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { [addTemplateLists] results, error in
        if let error = error as NSError? {
          if error.code == 11 {
            addTemplateLists()
          }
          print(error.localizedDescription)
          return
        } else {
          if let results = results, results.count == 0 {
            addTemplateLists()
          }
        }
      }
    }
  }
  
  private func addTemplateLists() {
    let templateLists = SSMocker<ListModel>.loadGenericObjectsFromLocalJson(fileName: "TemplateLists")
    let templateItems = SSMocker<ItemModelCodable>.loadGenericObjectsFromLocalJson(fileName: "TemplateItems")
    
    var allItemsList: List?
    for templateList in templateLists {
      
      var list = templateList
      list.title = templateList.title.localize()
      let dbList = addList(list, response: nil)
      
      if templateList.type == ListType.all.rawValue {
        allItemsList = dbList
      }
      
      for (index, templateItem) in templateItems.enumerated() {
        if index <= 4, templateList.type == ListType.reminder.rawValue {
          var item = templateItem.toItemModel()
          item.title = templateItem.title
          item.parentList = dbList
          var notifDate: Date?
          switch index {
          case 0:
            notifDate = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date()) ?? Date()
          case 1:
            notifDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date()) ?? Date()
          case 2:
            notifDate = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date()) ?? Date()
          case 3:
            notifDate = Calendar.current.date(bySettingHour: 16, minute: 0, second: 0, of: Date()) ?? Date()
          case 4:
            notifDate = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date()
          default:
            print("Another index of template items for reminders")
          }
          item.notifDate = notifDate

          addItem(item, allItemsList: allItemsList, response: nil)

        } else if index > 4, index <= 6, templateList.type == ListType.countdown.rawValue {
          var item = templateItem.toItemModel()
          item.title = templateItem.title
          item.parentList = dbList
          var notifDate: Date?
          switch index {
          case 5:
            notifDate = Date()
          case 6:
            var dateComponents = DateComponents()
            dateComponents.year = 1989
            dateComponents.month = 8
            dateComponents.day = 2
            dateComponents.hour = 0
            dateComponents.minute = 0
            dateComponents.timeZone = Calendar.current.timeZone
            notifDate = Calendar.current.date(from: dateComponents)
          default:
            print("Another index of template items for coundowns")
          }
          item.notifDate = notifDate
          addItem(item, allItemsList: allItemsList, response: nil)

        } else if index > 6, index <= 9, templateList.type == ListType.note.rawValue {
          var item = templateItem.toItemModel()
          item.title = templateItem.title
          item.parentList = dbList
          addItem(item, allItemsList: allItemsList, response: nil)
        }
      }
      
      if let last = templateLists.last, templateList == last {
        Defaults.isDatabaseConfigured = true
      }
      
    }
  }
  
  //MARK: - List Related Functions
  func addList(_ list: ListModel, response: ((Bool) -> Void)?) -> List {
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
  func updateIsFavorite(isFavorite: Bool = true, favoriteList: List?, item: Item) {
    favoriteList?.itemsCount += 1
    item.isFavorite = isFavorite
    CoreDataStack.shared.saveContext()
  }
  func addItem(_ item: ItemModel, allItemsList: List?, response: ((Bool) -> Void)?) {
    allItemsList?.itemsCount += 1
    item.parentList?.itemsCount += 1
    
    _ = item.asDBItem()
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
    CoreDataStack.managedContext.delete(item)
    CoreDataStack.shared.saveContext()
  }
  
  func update(Item item: Item, response: ((Bool) -> Void)?) {
    CoreDataStack.shared.saveContext()
  }
  //MARK: - Shared
  
  func resetFactory() {
    
  }
  
  
}
