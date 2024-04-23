//
//  DBManager.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import CoreData
import CloudKit
import SwiftLocalNotification
import Haptico

final public class DBManager: DatabaseManagerProtocol {
  
  
  private static let scheduler = SwiftLocalNotification()
  //MARK: - Configuration
  func checkIsUserLoggedInIcloud(completion: @escaping (_ userId: String?)->()) {
    CKContainer.default().fetchUserRecordID { (id, err) in
      if let error = err as NSError? {
        completion(nil)
        print("Error with code: \(error.code), user is not logged in iCloud")
      } else {
        let idString = String(describing: id?.recordName)
        completion(idString)
        print("User iCloud id: \(idString)")
      }
    }
  }
  
  func getListsFromCloudKit(completion: @escaping(_ haveList: Bool?) -> ()) {
    let query = CKQuery(recordType: "CD_List", predicate: NSPredicate(value: true))
    CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { results, error in
      if let error = error as NSError? {
        // Error code 11 = no lists, error code 9 = not authenticated
        if error.code == 11 {
          completion(false)
        }
        print("error on getting list with err: \(error.localizedDescription)")
        return
      } else {
        if results?.count == 0 {
          completion(false)
        } else {
          completion(true)
        }
      }
    }
  }
  
  var allItemsList: List?
  
  func configureDataBase(templates: [TemplateList]) {
    
    if templates.isEmpty {
      addAllAndImportantList()
    } else {
      CoreDataStack.shared.deleteAllRecords(entityName: "List")
      CoreDataStack.shared.deleteAllRecords(entityName: "Item")
      let templateLists = SSMocker<ListModel>.loadGenericObjectsFromLocalJson(fileName: "TemplateLists")
      if let allList = templateLists.filter({$0.type == ListType.all.rawValue}).first {
        allItemsList = addList(allList, withHaptic: false, response: nil)
      }
      if let favList = templateLists.filter({$0.type == ListType.favorites.rawValue}).first {
        _ = addList(favList, withHaptic: false, response: nil)
      }
      for list in templates {
        addListWithItem(list: list)
      }
    }
  }
  private func addListWithItem(list: TemplateList) {
    
    
    let templateList = SSMocker<ListModel>.loadGenericObjectsFromLocalJson(fileName: "TemplateLists").filter{$0.type == list.rawValue}.first!
    let templateItems = SSMocker<ItemModelCodable>.loadGenericObjectsFromLocalJson(fileName: "TemplateItems").filter { (item) -> Bool in
      return item.listId == list.rawValue
    }
    switch list {
      
    case .motivations:
      var ls = templateList
      ls.title = templateList.title.localize()
      let dbList = addList(ls, withHaptic: false, response: nil)
      for (index, templateItem) in templateItems.enumerated() {
        var item = templateItem.toItemModel()
        item.title = templateItem.title
        item.parentList = dbList
        item.isFavorite = templateItem.isFavorite
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
        item.repeats = RepeatingInterval.daily
        addItem(item, allItemsList: allItemsList, withHaptic: false, response: nil)
      }
    case .birthdays:
      var ls = templateList
      ls.title = templateList.title.localize()
      let dbList = addList(ls, withHaptic: false, response: nil)
      for (index, templateItem) in templateItems.enumerated() {
        var item = templateItem.toItemModel()
        item.title = templateItem.title
        item.parentList = dbList
        item.isFavorite = templateItem.isFavorite
        var notifDate: Date?
        switch index {
        case 0:
          notifDate = Date()
        case 1:
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
        item.repeats = RepeatingInterval.yearly
        
        addItem(item, allItemsList: allItemsList, withHaptic: false, response: nil)
      }
      
    case .geroceries:
      var ls = templateList
      ls.title = templateList.title.localize()
      let dbList = addList(ls, withHaptic: false, response: nil)
      for (_, templateItem) in templateItems.enumerated() {
        var item = templateItem.toItemModel()
        item.title = templateItem.title
        item.parentList = dbList
        item.isFavorite = templateItem.isFavorite
        addItem(item, allItemsList: allItemsList, withHaptic: false, response: nil)
      }
    }
    
  }
  private func addAllAndImportantList() {
    let allAndImportantLists = SSMocker<ListModel>.loadGenericObjectsFromLocalJson(fileName: "TemplateLists").filter{$0.type == 100 || $0.type == 98}
    for templateList in allAndImportantLists {
      var list = templateList
      list.title = templateList.title.localize()
      _ = addList(list, withHaptic: false, response: nil)
    }
    //Defaults.isDatabaseConfigured = true
  }
  
  //MARK: - List Related Functions
  func addList(_ list: ListModel, withHaptic: Bool = true, response: ((Bool) -> Void)?) -> List {
    if withHaptic {
      Haptico.shared().generate(.success)
    }
    let dbList = list.asDBList()
    CoreDataStack.shared.saveContext()
    return dbList
  }
  
  
  func delete(List list: List, response: ((Bool) -> Void)?) {
    CoreDataStack.managedContext.delete(list)
    CoreDataStack.shared.saveContext()
    Haptico.shared().generate(.success)
  }
  
  func update(List list: List, response: ((Bool) -> Void)?) {
    CoreDataStack.shared.saveContext()
    Haptico.shared().generate(.success)
  }
  //MARK: - Item Related Functions
  func updateIsFavorite(isFavorite: Bool = true, favoriteList: List?, item: Item) {
    if isFavorite {
      favoriteList?.itemsCount += 1
    } else {
      favoriteList?.itemsCount -= 1
    }
    item.isFavorite = isFavorite
    CoreDataStack.shared.saveContext()
    Haptico.shared().generate(.success)
  }
  func updateState(item: Item, state: ItemState) {
    if state == .done {
      DBManager.scheduler.cancel(notificationIds: item.id ?? "")
    } else {
      if let notifDate = item.notifDate, let repeats = item.repeats {
        let notifModel = SwiftLocalNotificationModel(title: item.desc ?? "", body: item.title ?? "", date: notifDate, repeating: RepeatingInterval(rawValue: repeats) ?? .none)
        item.id = DBManager.scheduler.schedule(notification: notifModel)
      }
    }
    item.state = state.rawValue
    CoreDataStack.shared.saveContext()
    Haptico.shared().generate(.success)
  }
  
  func addItem(_ item: ItemModel, allItemsList: List?, withHaptic: Bool = true, response: ((Bool) -> Void)?) {
    allItemsList?.itemsCount += 1
    item.parentList?.itemsCount += 1
    
    let dbItem = item.asDBItem()
    
    if let notifDate = item.notifDate, let repeats = item.repeats {
      let notifModel = SwiftLocalNotificationModel(title: item.description ?? "", body: item.title, date: notifDate, repeating: repeats)
      dbItem.id = DBManager.scheduler.schedule(notification: notifModel)
    }
    
    CoreDataStack.shared.saveContext()
    
    if withHaptic {
      Haptico.shared().generate(.success)
    }
  }
  func update(Item item: Item, isNotifDateChanged: Bool, response: ((Bool) -> Void)?) {
    if isNotifDateChanged {
      DBManager.scheduler.cancel(notificationIds: item.id ?? "")
      
      if let notifDate = item.notifDate, let repeats = item.repeats {
        let notifModel = SwiftLocalNotificationModel(title: item.title ?? "", body: item.desc ?? "", date: notifDate, repeating: RepeatingInterval(rawValue: repeats) ?? RepeatingInterval.none)
        item.id = DBManager.scheduler.schedule(notification: notifModel)
      }
    }
    CoreDataStack.shared.saveContext()
    Haptico.shared().generate(.success)
  }
  
  func delete(Item item: Item, allItemsList: List?, favoriteList: List?, response: ((Bool) -> Void)?) {
    allItemsList?.itemsCount -= 1
    item.list?.itemsCount -= 1
    if item.isFavorite {
      favoriteList?.itemsCount -= 1
    }
    DBManager.scheduler.cancel(notificationIds: item.id ?? "")
    CoreDataStack.managedContext.delete(item)
    CoreDataStack.shared.saveContext()
    
    Haptico.shared().generate(.success)
  }
  
  
  //MARK: - Shared
  
  func resetFactory() {
    
  }
  
  
}
