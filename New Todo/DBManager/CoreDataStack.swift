//
//  CoreDataStack.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
  static let shared = CoreDataStack()
  
  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentCloudKitContainer = {
    let container = NSPersistentCloudKitContainer(name: "CoreDataCloudKit")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  static var managedContext: NSManagedObjectContext {
    let context = CoreDataStack.shared.persistentContainer.viewContext
    context.automaticallyMergesChangesFromParent = true
    return context
  }
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
