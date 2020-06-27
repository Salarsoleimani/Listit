//
//  HomeCollectionViewDelegate.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-23.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

extension HomeController: UICollectionViewDelegate {
  private func updateItemsTableView(_ list: List, selectedListItem: Int) {
    let listType = ListType(rawValue: list.type) ?? ListType.default
    //let filteredItems = allItems.filter{ $0.list == allLists[selectedListRow] }
    var predicate: NSPredicate?
    
    switch listType {
    case .reminder:
      predicate = NSPredicate(format: "list.id == %@", list.id ?? "")
    case .countdown:
      predicate = NSPredicate(format: "list.id == %@", list.id ?? "")
    case .note:
      predicate = NSPredicate(format: "list.id == %@", list.id ?? "")
    case .favorites:
      predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
    case .all:
      predicate = nil
      //    case .today:
      //      print("Do it later [TODO]")
      //      // Get the current calendar with local time zone
      //      var calendar = Calendar.current
      //      calendar.timeZone = NSTimeZone.local
      //
      //      // Get today's beginning & end
      //      let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
      //      let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
      //      // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time
      //
      //      // Set predicate as date being today's date
      //      let fromPredicate = NSPredicate(format: "%@ >= %@", date as NSDate, dateFrom as NSDate)
      //      let toPredicate = NSPredicate(format: "%@ < %@", date as NSDate, dateTo as NSDate)
      //      let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
      //      predicate = datePredicate
      //      let filteredItems = allItems.filter { (item) -> Bool in
      //        if let notifDate = item.notifDate {
      //          return Calendar.current.isDateInToday(notifDate)
      //        }
      //        if let repeats = item.repeats, let repeatInterval = RepeatingInterval(rawValue: repeats) {
      //          return repeatInterval == .daily || repeatInterval == .hourly || repeatInterval == .minute
      //        }
      //        return false
      //      }
    //      addDataToItemsTableView(data: filteredItems)
    case .none:
      predicate = nil
    }
    itemsDataSource.frc.fetchRequest.predicate = predicate
    itemsDataSource.performFetch()
    itemsTableView.reloadData()
  }
  
  private func listSelected(_ list: List, selectedItem: Int) {
    selectedList = list
    updateItemsTableView(list, selectedListItem: selectedItem)
    if let type = ListType(rawValue: list.type) {
      if type == .all || type == .favorites {
        UIView.animate(withDuration: 0.25) { [quickAddItembuttonContainerView] in
          quickAddItembuttonContainerView?.isHidden = true
        }
      } else {
        UIView.animate(withDuration: 0.25) { [quickAddItembuttonContainerView] in
          quickAddItembuttonContainerView?.isHidden = false
        }
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let listCell = collectionView.cellForItem(at: indexPath) as? ListCell {
      let selectedList = listCell.viewModel.model
      listSelected(selectedList, selectedItem: indexPath.item)
    }
  }
  func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    if collectionView == listsCollectionView, let listCell = collectionView.cellForItem(at: indexPath) as? ListCell {
      let selectedList = listCell.viewModel.model
      let type = ListType(rawValue: selectedList.type) ?? ListType.default
      if type != .favorites, type != .all {
        let listConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [editListAction, addNewItemAction, deleteListAction, quickAddNewItemAction] action in
          let addNewTitle = "add_new_item_to_list_action".localize()
          let typeTitle = type.quantityTitle().dropLast().description
          let addItem = UIAction(title: "\(addNewTitle) \(typeTitle)", image: UIImage(systemName: "plus.circle"), handler: {action in
            addNewItemAction(selectedList)
          })
          let quickAddNewTitle = "quick_add_new_item_to_list_action".localize()
          let quickAddItem = UIAction(title: "\(quickAddNewTitle) \(typeTitle)", image: UIImage(systemName: "plus.circle"), handler: {action in
            quickAddNewItemAction(selectedList)
          })
          let delete = UIAction(title: "delete_list_action".localize(), image: UIImage(systemName: "trash.fill"), attributes: .destructive, handler: { action in
            deleteListAction(selectedList)
          })
          let edit = UIAction(title: "edit_list_action".localize(), image: UIImage(systemName: "square.and.pencil"), handler: {action in
            editListAction(selectedList)
          })
          
          return UIMenu(title: "", image: nil, identifier: nil, children: [quickAddItem, addItem, edit, delete])
        }
        
        return listConfiguration
      }
    }
    return nil
  }
  
  private func editListAction(_ list: List) {
    navigator.toAddOrEditList(list: list, delegate: self)
  }
  private func addNewItemAction(_ list: List) {
    let allItemsList = listsDataSource.frc.fetchedObjects?.filter{$0.type == ListType.all.rawValue}.first

    navigator.toAddOrEditItem(item: nil, forList: list, lists: yourLists, allItemsList: allItemsList)
  }
  private func quickAddNewItemAction(_ list: List) {
    selectedList = list
    quickAddListButtonPressed(0)
  }
  private func deleteListAction(list: List) {
    let cancelAction = UIAlertAction(title: "cancel_list_action".localize(), style: .cancel)
    let deleteAction = UIAlertAction(title: "delete_list_action".localize(), style: .destructive) { [deleteList] (action) in
      deleteList(list)
    }
    let listTitle = list.title ?? ""
    let deleteListTitleAlert = String(format: "delete_list_title_alert".localize(), listTitle)
    let deleteListDescAlert = String(format: "delete_list_desc_alert".localize(), arguments: [listTitle, listTitle])
    let alertt = navigator.simpleAlert(title: deleteListTitleAlert, message: deleteListDescAlert, actions: [cancelAction, deleteAction])
    present(alertt, animated: true, completion: nil)
  }
  private func deleteList(_ list: List) {
    dbManager.delete(List: list, response: nil)
    if let items = list.items?.allObjects as? [Item] {
      for item in items where item.list == list {
        dbManager.delete(Item: item, response: nil)
      }
    }
    
  }
}
