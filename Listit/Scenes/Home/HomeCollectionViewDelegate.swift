////
////  HomeCollectionViewDelegate.swift
////  Listit
////
////  Created by Salar Soleimani on 2020-06-23.
////  Copyright © 2020 ssmobileapps.com All rights reserved.
////
//
//import UIKit
//import Haptico
//
//extension HomeController: UICollectionViewDelegate {
//  private func updateItemsTableView(_ list: List, selectedListItem: Int) {
//    let listType = list.getListType()
//    //let filteredItems = allItems.filter{ $0.list == allLists[selectedListRow] }
//    let predicate = properPredicateFor(ListType: listType, listId: list.id ?? "")
//    let stateSort = NSSortDescriptor(key: "state", ascending: true)
//    itemsDataSource.frc.fetchRequest.sortDescriptors = [stateSort, NSSortDescriptor(key: "createdAt", ascending: false)]
//    
//    fetchItems(predicate)
//    thereAreItems(listType: listType)
//  }
//  
//  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    if scrollView.contentOffset.x > 280 {
//      UIView.animate(withDuration: 0.25) { [changeAddListButtonLayoutToBack] in
//        changeAddListButtonLayoutToBack(true)
//      }
//    } else if scrollView.contentOffset.x <= 280, addListContainerViewLeftAnchor.constant == -50 {
//      UIView.animate(withDuration: 0.25) { [changeAddListButtonLayoutToBack] in
//        changeAddListButtonLayoutToBack(false)
//      }
//    }
//   
//  }
//  internal func changeAddListButtonLayoutToBack(_ isBackButtonHidden: Bool) {
//    if isBackButtonHidden {
//      backToFirstButtonLeftAnchor.constant = 8
//      addListContainerViewLeftAnchor.constant = -50
//      view.layoutIfNeeded()
//      return
//    }
//    backToFirstButtonLeftAnchor.constant = -50
//    addListContainerViewLeftAnchor.constant = 0
//    view.layoutIfNeeded()
//  }
//  
//  internal func fetchItems(_ predicate: NSPredicate? = nil) {
//    itemsDataSource.frc.fetchRequest.predicate = predicate
//    itemsDataSource.performFetch()
//  }
//  internal func thereAreItems(listType: ListType? = nil) {
//    if itemsDataSource.frc.fetchedObjects?.isEmpty ?? false {
//      noItemsLabel.text = listType != .favorites ? String(format: "no_items_in_list_title".localize(), selectedList?.title ?? "") : "no_items_in_importants_title".localize()
//      noItemsStackView.isHidden = false
//      noItemsImageView.isHidden = listType != .favorites ? false : true
//    } else {
//      noItemsStackView.isHidden = true
//    }
//    itemsTableView.reloadData()
//  }
//  internal func listSelected(_ list: List, selectedItem: Int) {
//    Haptico.shared().generate(.light)
//    let type = list.getListType()
//    if type == .all {
//      selectedList = nil
//      navigationItem.title = "all_lists_type".localize()
//    } else if type == .favorites {
//      selectedList = nil
//      navigationItem.title = "favorites_lists_type".localize()
//    } else {
//      selectedList = list
//    }
//    updateItemsTableView(list, selectedListItem: selectedItem)
//    
//    autoLayoutAddItemButtonUI(type)
//    
//  }
//  
//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    if let listCell = collectionView.cellForItem(at: indexPath) as? ListCell {
//      let selectedList = listCell.viewModel.model
//      listSelected(selectedList, selectedItem: indexPath.item)
//    }
//  }
//  
//  func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//    if collectionView == listsCollectionView, let listCell = collectionView.cellForItem(at: indexPath) as? ListCell {
//      let selectedList = listCell.viewModel.model
//      let type = selectedList.getListType()
//      if type != .favorites, type != .all {
//        let listConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [editListAction, deleteListAction, quickAddNewItemAction] action in
//          let typeTitle = type.quantityTitle().dropLast().description
//          
//          let quickAddNewTitle = "quick_add_new_item_to_list_action".localize()
//          let quickAddItem = UIAction(title: "\(quickAddNewTitle) \(typeTitle)", image: UIImage(systemName: "plus.circle"), handler: {action in
//            quickAddNewItemAction(selectedList)
//          })
//          let delete = UIAction(title: "delete_list_action".localize(), image: UIImage(systemName: "trash.fill"), attributes: .destructive, handler: { action in
//            deleteListAction(selectedList)
//          })
//          let edit = UIAction(title: "edit_list_action".localize(), image: UIImage(systemName: "square.and.pencil"), handler: {action in
//            editListAction(selectedList)
//          })
//          
//          return UIMenu(title: "", image: nil, identifier: nil, children: [quickAddItem, edit, delete])
//        }
//        
//        return listConfiguration
//      }
//    }
//    return nil
//  }
//  
//  private func editListAction(_ list: List) {
//    navigator.toAddOrEditList(list: list, delegate: self)
//  }
//  private func quickAddNewItemAction(_ list: List) {
//    selectedList = list
//    quickAddItem()
//  }
//  private func deleteListAction(list: List) {
//    Haptico.shared().generate(.light)
//    let cancelAction = UIAlertAction(title: "cancel_list_action".localize(), style: .cancel)
//    let deleteAction = UIAlertAction(title: "delete_list_action".localize(), style: .destructive) { [deleteList] (action) in
//      deleteList(list)
//    }
//    let listTitle = list.title ?? ""
//    let deleteListTitleAlert = String(format: "delete_list_title_alert".localize(), listTitle)
//    let deleteListDescAlert = String(format: "delete_list_desc_alert".localize(), arguments: [listTitle, listTitle])
//    let alertt = navigator.simpleAlert(title: deleteListTitleAlert, message: deleteListDescAlert, actions: [cancelAction, deleteAction])
//    present(alertt, animated: true, completion: nil)
//  }
//  private func deleteList(_ list: List) {
//    dbManager.delete(List: list, response: nil)
//    if let allItemsList = allItemsList {
//      listSelected(allItemsList, selectedItem: 0)
//    }
//    Utility.delay(0.1) { [itemsDataSource, dbManager, favoriteList, allItemsList] in
//      if let items = itemsDataSource?.frc.fetchedObjects {
//        for item in items where item.list == nil {
//          dbManager.delete(Item: item, allItemsList: allItemsList, favoriteList: favoriteList, response: nil)
//        }
//      }
//    }
//    
//  }
//  internal func properPredicateFor(ListType listType: ListType, listId: String) -> NSPredicate? {
//    var predicate: NSPredicate?
//    
//    switch listType {
//    case .reminder:
//      predicate = NSPredicate(format: "list.id == %@", listId)
//    case .countdown:
//      predicate = NSPredicate(format: "list.id == %@", listId)
//    case .note:
//      predicate = NSPredicate(format: "list.id == %@", listId)
//    case .habit:
//      predicate = NSPredicate(format: "list.id == %@", listId)
//      
//    case .favorites:
//      predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
//    case .all:
//      predicate = nil
//      //    case .today:
//      //      print("Do it later [TODO]")
//      //      // Get the current calendar with local time zone
//      //      var calendar = Calendar.current
//      //      calendar.timeZone = NSTimeZone.local
//      //
//      //      // Get today's beginning & end
//      //      let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
//      //      let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
//      //      // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time
//      //
//      //      // Set predicate as date being today's date
//      //      let fromPredicate = NSPredicate(format: "%@ >= %@", date as NSDate, dateFrom as NSDate)
//      //      let toPredicate = NSPredicate(format: "%@ < %@", date as NSDate, dateTo as NSDate)
//      //      let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
//      //      predicate = datePredicate
//      //      let filteredItems = allItems.filter { (item) -> Bool in
//      //        if let notifDate = item.notifDate {
//      //          return Calendar.current.isDateInToday(notifDate)
//      //        }
//      //        if let repeats = item.repeats, let repeatInterval = RepeatingInterval(rawValue: repeats) {
//      //          return repeatInterval == .daily || repeatInterval == .hourly || repeatInterval == .minute
//      //        }
//      //        return false
//      //      }
//    //      addDataToItemsTableView(data: filteredItems)
//    case .none:
//      predicate = nil
//      
//    }
//    return predicate
//  }
//}
