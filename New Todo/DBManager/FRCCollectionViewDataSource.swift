//
//  FRCCollectionViewDataSource.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-18.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import CoreData

protocol FRCCollectionViewDelegate: class {
  func frcCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class FRCCollectionViewDataSource<FetchRequestResult: NSFetchRequestResult>: NSObject, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
  
  let frc: NSFetchedResultsController<FetchRequestResult>
  weak var collectionView: UICollectionView?
  weak var delegate: FRCCollectionViewDelegate?
  
  private var blockOperation = BlockOperation()
  
  init(fetchRequest: NSFetchRequest<FetchRequestResult>, context: NSManagedObjectContext, sectionNameKeyPath: String?) {
    frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
    super.init()
    frc.delegate = self
  }
  convenience init(fetchRequest: NSFetchRequest<FetchRequestResult>, context: NSManagedObjectContext, sectionNameKeyPath: String?, delegate: FRCCollectionViewDelegate, collectionView: UICollectionView) {
    self.init(fetchRequest: fetchRequest, context: context, sectionNameKeyPath: sectionNameKeyPath)
    
    self.delegate = delegate
    self.collectionView = collectionView
  }
  func performFetch() throws {
    try frc.performFetch()
  }
  
  func object(at indexPath: IndexPath) -> FetchRequestResult {
    return frc.object(at: indexPath)
  }
  
  // MARK: - UICollectionViewDataSource
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return frc.sections?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let sections = frc.sections else { return 0 }
    
    return sections[section].numberOfObjects
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let delegate = delegate {
      return delegate.frcCollectionView(collectionView, cellForItemAt: indexPath)
    } else {
      return UICollectionViewCell()
    }
  }
  
  // MARK: - NSFetchedResultsControllerDelegate
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    blockOperation = BlockOperation()
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    let sectionIndexSet = IndexSet(integer: sectionIndex)

    switch type {
    case .insert:
      blockOperation.addExecutionBlock {
        self.collectionView?.insertSections(sectionIndexSet)
      }
    case .delete:
      blockOperation.addExecutionBlock {
        self.collectionView?.deleteSections(sectionIndexSet)
      }
    case .update:
      blockOperation.addExecutionBlock {
        self.collectionView?.reloadSections(sectionIndexSet)
      }
    case .move:
      assertionFailure()
      break
    @unknown default:
      fatalError()
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      guard let newIndexPath = newIndexPath else { break }
      
      blockOperation.addExecutionBlock {
        self.collectionView?.insertItems(at: [newIndexPath])
      }
    case .delete:
      guard let indexPath = indexPath else { break }
      
      blockOperation.addExecutionBlock {
        self.collectionView?.deleteItems(at: [indexPath])
      }
    case .update:
      guard let indexPath = indexPath else { break }
      
      blockOperation.addExecutionBlock {
        self.collectionView?.reloadItems(at: [indexPath])
      }
    case .move:
      guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
      
      blockOperation.addExecutionBlock {
        self.collectionView?.moveItem(at: indexPath, to: newIndexPath)
      }
    @unknown default:
      fatalError()
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    collectionView?.performBatchUpdates({
      self.blockOperation.start()
      }, completion: nil)
  }
  
}
