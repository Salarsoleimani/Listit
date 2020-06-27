//
//  HomeItems.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-23.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class ItemsTableViewDataSource: FRCTableViewDataSource<Item> {
  
}
extension HomeController: FRCTableViewDelegate {
  func frcTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let itemCell = tableView.cellForRow(at: indexPath) as? ItemCell {
      if selecteItemIndexpaths.contains(indexPath) {
        for (index, indexP) in selecteItemIndexpaths.enumerated() {
          if indexP == indexPath {
            selecteItemIndexpaths.remove(at: index)
          }
        }
        itemCell.isShowingDetail = true
      } else {
        selecteItemIndexpaths.append(indexPath)
        itemCell.isShowingDetail = false
      }
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }
  }
  func frcTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.cellId, for: indexPath) as! ItemCell
    let item = itemsDataSource.object(at: indexPath)
    cell.bindData(withViewModel: ItemViewModel(model: item))
    cell.delegate = self // for swipeki
    return cell
  }
  
  func frcTableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    if tableView == itemsTableView, let cell = tableView.cellForRow(at: indexPath) as? ItemCell {
      let item = cell.viewModel.model
      let listConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [dbManager, navigator, yourLists, deleteItem, listsDataSource] action in
        
        let markAsFinishedItem = UIAction(title: "mark_as_completed_item_title".localize(), image: UIImage(systemName: "checkmark.circle"), handler: { [dbManager] action in
          dbManager.updateState(item: item, state: ItemState.done)
        })
        let markAsUnfinishedItem = UIAction(title: "uncomplete_item_title".localize(), image: UIImage(systemName: "arrow.uturn.left.circle"), handler: { [dbManager] action in
          dbManager.updateState(item: item, state: ItemState.doing)
        })
        let favoriteItem = UIAction(title: "favorite_item_title".localize(), image: UIImage(systemName: "star.fill"), handler: { [dbManager] action in
          let favoriteList = listsDataSource?.frc.fetchedObjects?.filter{$0.type == ListType.favorites.rawValue}.first
          dbManager.updateIsFavorite(isFavorite: true, favoriteList: favoriteList, item: item)
        })
        let unfavoriteItem = UIAction(title: "unfavorite_item_title".localize(), image: UIImage(systemName: "star.slash.fill"), handler: { [dbManager] action in
          let favoriteList = listsDataSource?.frc.fetchedObjects?.filter{$0.type == ListType.favorites.rawValue}.first
          
          dbManager.updateIsFavorite(isFavorite: false, favoriteList: favoriteList, item: item)
        })
        
        let delete = UIAction(title: "delete_list_action".localize(), image: UIImage(systemName: "trash.fill"), attributes: .destructive, handler: { action in
          deleteItem(item, indexPath)
        })
        let edit = UIAction(title: "edit_list_action".localize(), image: UIImage(systemName: "square.and.pencil"), handler: {action in
          let allItemsList = listsDataSource?.frc.fetchedObjects?.filter{$0.type == ListType.all.rawValue}.first
          
          navigator.toAddOrEditItem(item: item, forList: item.list, lists: yourLists, allItemsList: allItemsList)
        })
        let itemState = ItemState(rawValue: item.state) ?? ItemState.default
        switch itemState {
        case .doing:
          if item.isFavorite {
            return UIMenu(title: "", image: nil, identifier: nil, children: [markAsFinishedItem, unfavoriteItem, edit, delete])
          } else {
            return UIMenu(title: "", image: nil, identifier: nil, children: [markAsFinishedItem, favoriteItem, edit, delete])
          }
        case .done:
          if item.isFavorite {
            return UIMenu(title: "", image: nil, identifier: nil, children: [markAsUnfinishedItem, unfavoriteItem, edit, delete])
          } else {
            return UIMenu(title: "", image: nil, identifier: nil, children: [markAsUnfinishedItem, favoriteItem, edit, delete])
          }
        }
      }
      
      return listConfiguration
    }
    return nil
  }
  
  func frcTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //let itemsCVWidth = itemsTableView.frame.width
    var height: CGFloat = 50
    let items = itemsDataSource.frc.fetchedObjects
    
    if selecteItemIndexpaths.contains(indexPath) {
      if let items = items, indexPath.row < items.count {
        let specificItem = items[indexPath.row]
        let itemListType = ListType(rawValue: specificItem.list?.type ?? ListType.default.rawValue) ?? ListType.default
        switch itemListType {
        case .reminder:
          height =  124
        case .note:
          height = 80
        case .countdown:
          if specificItem.notifDate != nil {
            height = 166
          } else {
            height = 130
          }
        default: break
        }
        if let desc = specificItem.desc, !desc.isEmpty {} else {height -= 22}
      }
      return height
    }
    if let items = items, indexPath.row < items.count {
      let specificItem = items[indexPath.row]
      let itemListType = ListType(rawValue: specificItem.list?.type ?? ListType.default.rawValue) ?? ListType.default
      switch itemListType {
      case .reminder:
        height =  52
      case .note:
        height = 52
      case .countdown:
        if specificItem.notifDate != nil {
          height = 88
        } else {
          height = 52
        }
      default: break
      }
    }
    return height
  }
  private func deleteItem(_ item: Item, indexPath: IndexPath) {
    dbManager.delete(Item: item, response: nil)
  }
}
extension HomeController: SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    let itemCell = itemsTableView.cellForRow(at: indexPath) as! ItemCell
    if orientation == .left {
      let finishedOrUnfinished = SwipeAction(style: .default, title: nil) { [dbManager] action, indexPath in
        if itemCell.viewModel.finishedLineIsHidden {
          dbManager.updateState(item: itemCell.viewModel.model, state: ItemState.done)
        } else {
          dbManager.updateState(item: itemCell.viewModel.model, state: ItemState.doing)
        }
        itemCell.viewModel.finishedLineIsHidden = !itemCell.viewModel.finishedLineIsHidden
      }
      finishedOrUnfinished.hidesWhenSelected = true
      finishedOrUnfinished.accessibilityLabel = itemCell.viewModel.finishedLineIsHidden ? "mark_as_completed_item_title".localize() : "uncomplete_item_title".localize()
      
      let descriptor: ActionDescriptor = itemCell.viewModel.finishedLineIsHidden ? .finished : .unfinished
      configure(action: finishedOrUnfinished, with: descriptor)
      
      return [finishedOrUnfinished]
    }
    return nil
    //    else {
    //        let flag = SwipeAction(style: .default, title: nil, handler: nil)
    //        flag.hidesWhenSelected = true
    //        configure(action: flag, with: .flag)
    //
    //        let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
    //            self.emails.remove(at: indexPath.row)
    //        }
    //        configure(action: delete, with: .trash)
    //
    //        let cell = tableView.cellForRow(at: indexPath) as! MailCell
    //        let closure: (UIAlertAction) -> Void = { _ in cell.hideSwipe(animated: true) }
    //        let more = SwipeAction(style: .default, title: nil) { action, indexPath in
    //            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    //            controller.addAction(UIAlertAction(title: "Reply", style: .default, handler: closure))
    //            controller.addAction(UIAlertAction(title: "Forward", style: .default, handler: closure))
    //            controller.addAction(UIAlertAction(title: "Mark...", style: .default, handler: closure))
    //            controller.addAction(UIAlertAction(title: "Notify Me...", style: .default, handler: closure))
    //            controller.addAction(UIAlertAction(title: "Move Message...", style: .default, handler: closure))
    //            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: closure))
    //            self.present(controller, animated: true, completion: nil)
    //        }
    //        configure(action: more, with: .more)
    //
    //        return [delete, flag, more]
    //    }
  }
  func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
    var options = SwipeOptions()
    options.expansionStyle = orientation == .left ? .selection : .destructive
    options.buttonSpacing = 4
    options.backgroundColor = UIColor.systemGray6
    
    return options
  }
  func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
    action.title = descriptor.title()
    action.image = descriptor.image()
    action.backgroundColor = .clear
    action.textColor = descriptor.color()
    action.font = .systemFont(ofSize: 13)
    action.transitionDelegate = ScaleTransition.default
  }
  
}
extension HomeController {
  func configureItemsDataSource() {
    let itemsFetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    itemsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
    itemsFetchRequest.fetchBatchSize = 20
    
    itemsDataSource = ItemsTableViewDataSource(fetchRequest: itemsFetchRequest, context: CoreDataStack.managedContext, sectionNameKeyPath: nil, delegate: self, tableView: itemsTableView)
    itemsTableView.dataSource = itemsDataSource
    itemsTableView.delegate = itemsDataSource
    itemsDataSource.performFetch()
  }
}
