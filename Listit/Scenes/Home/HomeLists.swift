//
//  HomeLists.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-23.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

class ListsCollectionViewDataSource: FRCCollectionViewDataSource<List> {
  
}
extension HomeController: FRCCollectionViewDelegate {
  func frcCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIds.cellId, for: indexPath) as! ListCell
    let list = listsDataSource.object(at: indexPath)
    cell.bindData(withViewModel: ListItemViewModel(model: list))
    return cell
  }
}

extension HomeController {
  func configureListsDataSource() {
    let listsFetchRequest: NSFetchRequest<List> = List.fetchRequest()
    listsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
    listsFetchRequest.fetchBatchSize = 20
    listsDataSource = ListsCollectionViewDataSource(fetchRequest: listsFetchRequest, context: CoreDataStack.managedContext, sectionNameKeyPath: nil, delegate: self, collectionView: listsCollectionView)
    listsCollectionView.dataSource = listsDataSource
    listsDataSource.performFetch()

  }
}
