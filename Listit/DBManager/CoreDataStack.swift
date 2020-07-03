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
    let container = NSPersistentCloudKitContainer(name: "Listit")
    guard let description = container.persistentStoreDescriptions.first else {
      fatalError("No description found")
    }
    let options = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.ca.ssmobileapps.listit")

    description.cloudKitContainerOptions = options

    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
//  lazy var persistentContainer2: NSPersistentCloudKitContainer = {
//      let container = NSPersistentCloudKitContainer(name: "New_Todo")
//      
//      // Create a store description for a local store
//      let localStoreLocation = URL(fileURLWithPath: "/path/to/local.store")
//      let localStoreDescription =
//          NSPersistentStoreDescription(url: localStoreLocation)
//      localStoreDescription.configuration = "Local"
//      
//      // Create a store description for a CloudKit-backed local store
//      let cloudStoreLocation = URL(fileURLWithPath: "/path/to/cloud.store")
//      let cloudStoreDescription =
//          NSPersistentStoreDescription(url: cloudStoreLocation)
//      cloudStoreDescription.configuration = "Cloud"
//
//      // Set the container options on the cloud store
//      cloudStoreDescription.cloudKitContainerOptions =
//          NSPersistentCloudKitContainerOptions(
//              containerIdentifier: "iCloud.ca.ssmobileapps.newTodo.container")
//      
//      // Update the container's list of store descriptions
//      container.persistentStoreDescriptions = [
//          cloudStoreDescription,
//          localStoreDescription
//      ]
//      
//      // Load both stores
//      container.loadPersistentStores { storeDescription, error in
//          guard error == nil else {
//              fatalError("Could not load persistent stores. \(error!)")
//          }
//      }
//      
//      return container
//  }()
  
  static var managedContext: NSManagedObjectContext {
    let context = CoreDataStack.shared.persistentContainer.viewContext
    try? context.setQueryGenerationFrom(.current)
    context.automaticallyMergesChangesFromParent = true
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
  
  func deleteAllRecords(entityName: String) {
    let coord = persistentContainer.viewContext.persistentStoreCoordinator
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try coord?.execute(deleteRequest, with: persistentContainer.viewContext)
    } catch let error as NSError {
      debugPrint(error)
    }
  }
}
