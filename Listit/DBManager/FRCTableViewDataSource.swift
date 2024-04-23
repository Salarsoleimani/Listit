//
//  FRCTableViewDataSource.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-17.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import UIKit
import CoreData

protocol FRCTableViewDelegate: class {
  func frcTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  func frcTableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
  func frcTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
  func frcTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

class FRCTableViewDataSource<FetchRequestResult: NSFetchRequestResult>: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
  
  let frc: NSFetchedResultsController<FetchRequestResult>
  weak var tableView: UITableView?
  weak var delegate: FRCTableViewDelegate?
  
  init(fetchRequest: NSFetchRequest<FetchRequestResult>, context: NSManagedObjectContext, sectionNameKeyPath: String?) {
    frc = NSFetchedResultsController<FetchRequestResult>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
    
    super.init()
    
    frc.delegate = self
  }
  
  convenience init(fetchRequest: NSFetchRequest<FetchRequestResult>, context: NSManagedObjectContext, sectionNameKeyPath: String?, delegate: FRCTableViewDelegate, tableView: UITableView) {
    self.init(fetchRequest: fetchRequest, context: context, sectionNameKeyPath: sectionNameKeyPath)
    
    self.delegate = delegate
    self.tableView = tableView
  }
  
  func performFetch() {
    do {
      try frc.performFetch()
    } catch let err {
      print("error on fetchin lists: \(err)")
    }
  }
  
  func object(at indexPath: IndexPath) -> FetchRequestResult {
    return frc.object(at: indexPath)
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return frc.sections?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = frc.sections else { return 0 }
    
    return sections[section].numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let delegate = delegate {
      return delegate.frcTableView(tableView, cellForRowAt: indexPath)
    } else {
      return UITableViewCell()
    }
  }
  // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let delegate = delegate {
      delegate.frcTableView(tableView, didSelectRowAt: indexPath)
    }
  }
  func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    if let delegate = delegate {
      return delegate.frcTableView(tableView, contextMenuConfigurationForRowAt: indexPath, point: point)
    }
    return nil
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if let delegate = delegate {
      return delegate.frcTableView(tableView, heightForRowAt: indexPath)
    }
    return 0
  }
  // MARK: - NSFetchedResultsControllerDelegate
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView?.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    let sectionIndexSet = IndexSet(integer: sectionIndex)
    
    switch type {
    case .insert: tableView?.insertSections(sectionIndexSet, with: .automatic)
    case .delete: tableView?.deleteSections(sectionIndexSet, with: .automatic)
    case .update: tableView?.reloadSections(sectionIndexSet, with: .automatic)
    case .move: break
    @unknown default:
      fatalError()
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      guard let newIndexPath = newIndexPath else { break }
      tableView?.insertRows(at: [newIndexPath], with: .automatic)
    case .delete:
      guard let indexPath = indexPath else { break }
      tableView?.deleteRows(at: [indexPath], with: .automatic)
    case .update:
      guard let indexPath = indexPath else { break }
      tableView?.reloadRows(at: [indexPath], with: .automatic)
    case .move:
      guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
      tableView?.moveRow(at: indexPath, to: newIndexPath)
    @unknown default:
      fatalError()
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView?.endUpdates()
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {}
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return nil }

}

