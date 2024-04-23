////
////  HomeItems.swift
////  Listit
////
////  Created by Salar Soleimani on 2020-06-23.
////  Copyright © 2020 ssmobileapps.com All rights reserved.
////
//
//import UIKit
//import CoreData
//import SwipeCellKit
//import Haptico
//
//class ItemsTableViewDataSource: FRCTableViewDataSource<Item> {
//  
//}
//extension HomeController: FRCTableViewDelegate {
//  func frcTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    if selecteItemIndexpaths.contains(indexPath) {
//      for (index, indexP) in selecteItemIndexpaths.enumerated() where indexP == indexPath {
//        selecteItemIndexpaths.remove(at: index)
//      }
//    } else {
//      selecteItemIndexpaths.append(indexPath)
//    }
//    Haptico.shared().generate(.light)
//    tableView.reloadRows(at: [indexPath], with: .automatic)
//  }
//  
//  func frcTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.cellId, for: indexPath) as! ItemCell
//    let item = itemsDataSource.object(at: indexPath)
//    cell.bindData(withViewModel: ItemViewModel(model: item))
//    if selecteItemIndexpaths.contains(indexPath) {
//      cell.isShowingDetail = true
//    } else {
//      cell.isShowingDetail = false
//    }
//    cell.showDetail(cell.isShowingDetail)
//
//    cell.delegate = self // for swipekit
//    return cell
//  }
//  
//  func frcTableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//    if tableView == itemsTableView, let cell = tableView.cellForRow(at: indexPath) as? ItemCell {
//      let item = cell.viewModel.model
//      let listConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [dbManager, navigator, yourLists, deleteItem, favoriteList, allItemsList] action in
//        
//        let markAsFinishedItem = UIAction(title: "mark_as_completed_item_title".localize(), image: UIImage(systemName: "checkmark.circle"), handler: { [dbManager] action in
//          dbManager.updateState(item: item, state: ItemState.done)
//        })
//        let markAsUnfinishedItem = UIAction(title: "uncomplete_item_title".localize(), image: UIImage(systemName: "arrow.uturn.left.circle"), handler: { [dbManager] action in
//          dbManager.updateState(item: item, state: ItemState.doing)
//        })
//        let favoriteItem = UIAction(title: "favorite_item_title".localize(), image: UIImage(systemName: "star.fill"), handler: { [dbManager, favoriteList] action in
//          dbManager.updateIsFavorite(isFavorite: true, favoriteList: favoriteList, item: item)
//        })
//        let unfavoriteItem = UIAction(title: "unfavorite_item_title".localize(), image: UIImage(systemName: "star.slash.fill"), handler: { [dbManager, favoriteList] action in
//          dbManager.updateIsFavorite(isFavorite: false, favoriteList: favoriteList, item: item)
//        })
//        
//        let delete = UIAction(title: "delete_list_action".localize(), image: UIImage(systemName: "trash.fill"), attributes: .destructive, handler: { action in
//          deleteItem(item, indexPath)
//        })
//        let edit = UIAction(title: "edit_list_action".localize(), image: UIImage(systemName: "square.and.pencil"), handler: {action in
//          navigator.toAddOrEditItem(item: item, forList: item.list, lists: yourLists, allItemsList: allItemsList)
//        })
//        let itemState = ItemState(rawValue: item.state) ?? ItemState.default
//        switch itemState {
//        case .doing:
//          if item.isFavorite {
//            return UIMenu(title: "", image: nil, identifier: nil, children: [markAsFinishedItem, unfavoriteItem, edit, delete])
//          } else {
//            return UIMenu(title: "", image: nil, identifier: nil, children: [markAsFinishedItem, favoriteItem, edit, delete])
//          }
//        case .done:
//          if item.isFavorite {
//            return UIMenu(title: "", image: nil, identifier: nil, children: [markAsUnfinishedItem, unfavoriteItem, edit, delete])
//          } else {
//            return UIMenu(title: "", image: nil, identifier: nil, children: [markAsUnfinishedItem, favoriteItem, edit, delete])
//          }
//        }
//      }
//      
//      return listConfiguration
//    }
//    return nil
//  }
//  
//  func frcTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    //let itemsCVWidth = itemsTableView.frame.width
//    var height: CGFloat = 50
//    let items = itemsDataSource.frc.fetchedObjects
//    
//    if selecteItemIndexpaths.contains(indexPath) {
//      if let items = items, indexPath.row < items.count {
//        let specificItem = items[indexPath.row]
//        let itemListType = specificItem.list?.getListType() ?? .default
//        switch itemListType {
//        case .reminder:
//          height =  110
//        case .note:
//          height = 76
//        case .countdown:
//          if specificItem.notifDate != nil {
//            height = 150
//          } else {
//            height = 124
//          }
//        default: break
//        }
//        if let desc = specificItem.desc, !desc.isEmpty {} else {height -= 20}
//      }
//      return height
//    }
//    if let items = items, indexPath.row < items.count {
//      let specificItem = items[indexPath.row]
//      let itemListType = specificItem.list?.getListType() ?? .default
//      switch itemListType {
//      case .reminder:
//        height = 56
//      case .note:
//        height = 56
//      case .countdown:
//        if specificItem.notifDate != nil {
//          height = 88
//        } else {
//          height = 56
//        }
//      default: break
//      }
//    }
//    return height
//  }
//  private func deleteItem(_ item: Item, indexPath: IndexPath) {
//    Haptico.shared().generate(.success)
//    dbManager.delete(Item: item, allItemsList: allItemsList, favoriteList: favoriteList, response: nil)
//  }
//}
//// MARK:- SwipeActions
//extension HomeController: SwipeTableViewCellDelegate {
//  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//    let itemCell = itemsTableView.cellForRow(at: indexPath) as! ItemCell
//    if orientation == .left {
//      let finishedOrUnfinished = makeFinishedOrUnfinishedSwipeAction(itemCell.viewModel.model, finishedLineIsHidden: itemCell.viewModel.finishedLineIsHidden, cell: itemCell)
//      configure(action: finishedOrUnfinished.swipeAction, with: finishedOrUnfinished.descriptor)
//      return [finishedOrUnfinished.swipeAction]
//    }
//    let importantsOrNot = makeImportantOrNotSwipeAction(itemCell.viewModel.model)
//    configure(action: importantsOrNot.swipeAction, with: importantsOrNot.descriptor)
//    return [importantsOrNot.swipeAction]
//  }
//  private func makeImportantOrNotSwipeAction(_ item: Item) -> (swipeAction: SwipeAction, descriptor: ActionDescriptor) {
//    let importantsOrNot = SwipeAction(style: .default, title: nil) { [dbManager, favoriteList] action, indexPath in
//      if item.isFavorite {
//        dbManager.updateIsFavorite(isFavorite: false, favoriteList: favoriteList, item: item)
//      } else {
//        dbManager.updateIsFavorite(isFavorite: true, favoriteList: favoriteList, item: item)
//      }
//    }
//    let descriptor: ActionDescriptor = item.isFavorite ? .notImportant : .important
//    return (importantsOrNot, descriptor)
//  }
//  private func makeFinishedOrUnfinishedSwipeAction(_ item: Item, finishedLineIsHidden: Bool, cell: ItemCell) -> (swipeAction: SwipeAction, descriptor: ActionDescriptor) {
//    let finishedOrUnfinished = SwipeAction(style: .default, title: nil) { [dbManager] action, indexPath in
//      if finishedLineIsHidden {
//        dbManager.updateState(item: item, state: ItemState.done)
//      } else {
//        dbManager.updateState(item: item, state: ItemState.doing)
//      }
//      cell.viewModel.finishedLineIsHidden = !cell.viewModel.finishedLineIsHidden
//      cell.finishedLineImageView.isHidden = !finishedLineIsHidden
//    }
//    let descriptor: ActionDescriptor = finishedLineIsHidden ? .finished : .unfinished
//
//    return (finishedOrUnfinished, descriptor)
//  }
//  func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//    var options = SwipeOptions()
//    options.expansionStyle = .selection
//    options.buttonSpacing = 4
//    options.backgroundColor = .clear
//    
//    return options
//  }
//  private func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
//    action.title = descriptor.title()
//    action.image = descriptor.image()
//    action.backgroundColor = .clear
//    action.textColor = descriptor.color()
//    action.font = Fonts.h7Regular
//    action.transitionDelegate = ScaleTransition.default
//    action.hidesWhenSelected = true
//  }
//  
//}
//extension HomeController {
//  func configureItemsDataSource() {
//    let itemsFetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
//    itemsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "state", ascending: true), NSSortDescriptor(key: "createdAt", ascending: false)]
//    itemsFetchRequest.fetchBatchSize = 20
//    
//    itemsDataSource = ItemsTableViewDataSource(fetchRequest: itemsFetchRequest, context: CoreDataStack.managedContext, sectionNameKeyPath: nil, delegate: self, tableView: itemsTableView)
//    itemsTableView.dataSource = itemsDataSource
//    itemsTableView.delegate = itemsDataSource
//    fetchItems()
//  }
//}
