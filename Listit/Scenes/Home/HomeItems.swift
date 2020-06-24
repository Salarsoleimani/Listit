//
//  HomeItems.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-23.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import CoreData

class ItemsCollectionViewDataSource: FRCItemsCollectionDataSource<Item> {
  
}
extension HomeController: FRCItemsCollectionDelegate {
  func frcItemsCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIds.cellId, for: indexPath) as! ItemCell
    let item = itemsDataSource.object(at: indexPath)
    cell.rowLabel.text = String(indexPath.row + 1)
    cell.bindData(withViewModel: ItemViewModel(model: item))
    return cell
  }
}
extension HomeController {
  func configureItemsDataSource() {
    let itemsFetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    itemsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
    itemsFetchRequest.fetchBatchSize = 20

    itemsDataSource = ItemsCollectionViewDataSource(fetchRequest: itemsFetchRequest, context: CoreDataStack.managedContext, sectionNameKeyPath: nil, delegate: self, collectionView: itemsCollectionView)
    itemsCollectionView.dataSource = itemsDataSource
    itemsDataSource.performFetch()
  }
}
