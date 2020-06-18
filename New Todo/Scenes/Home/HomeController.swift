//
//  HomeController.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-01.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import CoreData
import SwiftLocalNotification

fileprivate class ListsCollectionViewDataSource: FRCCollectionViewDataSource<List> {
  
}
extension HomeController: FRCCollectionViewDelegate {
  func frcCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIds.cellId, for: indexPath) as! ListCell
    let list = listsDataSource.object(at: indexPath)
    cell.bindData(withViewModel: ListItemViewModel(model: list))
    return cell
  }
}
fileprivate class ItemsTableViewDataSource: FRCTableViewDataSource<Item> {
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let context = frc.managedObjectContext
    
    switch editingStyle {
    case .delete: context.delete(object(at: indexPath))
    default: return
    }
  }
  
}
extension HomeController: FRCTableViewDelegate {
  
  func frcTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.cellId, for: indexPath) as! ItemCell
    let item = itemsDataSource.object(at: indexPath)
    cell.bindData(withViewModel: ItemViewModel(model: item))
    return cell
  }
  
}

class HomeController: UIViewController {
  //MARK:- Outlets
  @IBOutlet weak var itemsTableView: UITableView!
  @IBOutlet weak var listsCollectionView: UICollectionView!
  
  @IBOutlet weak var addItemLabel: UILabelX!
  @IBOutlet weak var addItemButton: UIButton!
  @IBOutlet weak var addListButton: UIButton!
  @IBOutlet weak var addListLabel: UILabelX!
  
  //MARK:- Constants
  private let navigator: HomeNavigator
  private let dbManager: DatabaseManagerProtocol
  //MARK:- Variables
  lazy var allLists = listsDataSource.frc.fetchedObjects ?? [List]()
  lazy var yourLists: [List] = {
    let filteredList = allLists.filter { (list) -> Bool in
      let type = ListType(rawValue: list.type) ?? ListType.default
      return type != .all && type != .favorites && type != .today
    }
    return filteredList
  }()
  var allItems = [Item]()
  var filteredItems = [Item]()
  
  var selectedList: List?
  private var itemsDataSource: ItemsTableViewDataSource!
  private var listsDataSource: ListsCollectionViewDataSource!

  //MARK:- Initialization
  init(navigator: HomeNavigator, dbManager: DatabaseManagerProtocol) {
    self.navigator = navigator
    self.dbManager = dbManager
    super.init(nibName: "HomeController", bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  //MARK:- Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupNavigationButtons()
    
    let listNib = UINib(nibName: "ListCell", bundle: nil)
    listsCollectionView.register(listNib, forCellWithReuseIdentifier: Constants.CellIds.cellId)
    let listsFetchRequest: NSFetchRequest<List> = List.fetchRequest()
    listsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
    listsDataSource = ListsCollectionViewDataSource(fetchRequest: listsFetchRequest, context: CoreDataStack.managedContext, sectionNameKeyPath: nil, delegate: self, collectionView: listsCollectionView)
    
    listsCollectionView.delegate = self
    listsCollectionView.dataSource = listsDataSource
    try! listsDataSource.performFetch()

    let itemNib = UINib(nibName: "ItemCell", bundle: nil)
    itemsTableView.register(itemNib, forCellReuseIdentifier: Constants.CellIds.cellId)
    
    let itemsFetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    itemsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
    itemsDataSource = ItemsTableViewDataSource(fetchRequest: itemsFetchRequest, context: CoreDataStack.managedContext, sectionNameKeyPath: nil, delegate: self, tableView: itemsTableView)
    itemsTableView.dataSource = itemsDataSource
    itemsTableView.delegate = self
    try! itemsDataSource.performFetch()
    
//    dbManager.getAllLists { [unowned self, listsCollectionView] (dbLists) in
//      self.allLists = dbLists
//      listsCollectionView?.reloadData()
//    }
    
    //    dbManager.getAllItems { [unowned self, itemsTableView] (dbItems) in
    //      self.allItems = dbItems
    //      self.filteredItems = dbItems
    //      itemsTableView?.reloadData()
    //    }
    
  }
  //MARK:- Actions
  @IBAction private func addItemButtonPressed(_ sender: UIButton) {
    if !yourLists.isEmpty {
      navigator.toAddOrEditItem(item: nil, forList: selectedList, lists: yourLists)
    } else {
      navigator.toast(text: "add_item_no_list_error".localize(), hapticFeedbackType: .error, backgroundColor: Colors.error.value)
      navigator.toAddOrEditList(list: nil)
    }
  }
  @IBAction private func addListButtonPressed(_ sender: UIButton) {
    navigator.toAddOrEditList(list: nil)
  }
  @objc private func infoWalkthroughButtonPressed() {
    
  }
  @objc private func settingButtonPressed() {
    
  }
  //MARK:- Functions
  private func setupNavigationButtons() {
    let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(infoWalkthroughButtonPressed))
    let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingButtonPressed))
    navigationItem.leftBarButtonItems = [leftBarButton]
    navigationItem.rightBarButtonItems = [rightBarButton]
  }
}

extension HomeController: UICollectionViewDelegate {
  private func updateItemsTableView(_ selectedListRow: Int) {
    let listType = ListType(rawValue: allLists[selectedListRow].type) ?? ListType.default
    //let filteredItems = allItems.filter{ $0.list == allLists[selectedListRow] }
    var predicate: NSPredicate?
    
    switch listType {
    case .reminder:
      predicate = NSPredicate(format: "list.type == \(listType.rawValue)")
    case .countdown:
      predicate = NSPredicate(format: "list.type == \(listType.rawValue)")
    case .note:
      predicate = NSPredicate(format: "list.type == \(listType.rawValue)")
    case .favorites:
      predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
    case .all:
      predicate = nil
    case .today:
      print("Do it later [TODO]")
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
    try! itemsDataSource.performFetch()
    itemsTableView.reloadData()
  }
  
  private func listSelected(_ row: Int) {
    selectedList = allLists[row]
    navigationItem.title = allLists[row].title ?? ""
    updateItemsTableView(row)
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == listsCollectionView {
      listSelected(indexPath.item)
    }
  }
  func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    let index = indexPath.item < 0 ? 0 : indexPath.item
    let type = ListType(rawValue: allLists[index].type) ?? ListType.default
    if type != .today, type != .favorites, type != .all {
      let listConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [editListAction, addNewItemAction, deleteListAction] action in
        let addNewTitle = "add_new_item_to_list_action".localize()
        let typeTitle = type.quantityTitle().dropLast().description
        let addItem = UIAction(title: "\(addNewTitle) \(typeTitle)", image: UIImage(systemName: "plus.circle"), handler: {action in
          addNewItemAction(index)
        })
        
        let delete = UIAction(title: "delete_list_action".localize(), image: UIImage(systemName: "trash.fill"), attributes: .destructive, handler: { action in
          deleteListAction(index)
        })
        let edit = UIAction(title: "edit_list_action".localize(), image: UIImage(systemName: "square.and.pencil"), handler: {action in
          editListAction(index)
        })
        
        return UIMenu(title: "", image: nil, identifier: nil, children: [addItem, edit, delete])
      }
      
      return listConfiguration
    }
    return nil
  }
  private func editListAction(_ index: Int) {
    navigator.toAddOrEditList(list: allLists[index])
  }
  private func addNewItemAction(_ index: Int) {
    navigator.toAddOrEditItem(item: nil, forList: allLists[index], lists: yourLists)
  }
  private func deleteListAction(_ index: Int) {
    let cancelAction = UIAlertAction(title: "cancel_list_action".localize(), style: .cancel)
    let deleteAction = UIAlertAction(title: "delete_list_action".localize(), style: .destructive) { [deleteList] (action) in
      deleteList(index)
    }
    let listTitle = allLists[index].title ?? ""
    let deleteListTitleAlert = String(format: "delete_list_title_alert".localize(), listTitle)
    let deleteListDescAlert = String(format: "delete_list_desc_alert".localize(), arguments: [listTitle, listTitle])
    let alertt = navigator.simpleAlert(title: deleteListTitleAlert, message: deleteListDescAlert, actions: [cancelAction, deleteAction])
    present(alertt, animated: true, completion: nil)
  }
  private func deleteList(_ index: Int) {
    dbManager.delete(List: allLists[index], response: nil)
    for (itemIndex, item) in allItems.enumerated() where item.list == allLists[index] {
      dbManager.delete(Item: item, response: nil)
      allItems.remove(at: itemIndex)
    }
    allLists.remove(at: index)
    listsCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
    
  }
}
extension HomeController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let listHeight = 150
    return CGSize(width: 150, height: listHeight)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
  }
}
extension HomeController: UITableViewDelegate {
  private func deleteItem(_ item: Item, indexPath: IndexPath) {
    dbManager.delete(Item: item, response: nil)
  }
  
  func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    if let cell = tableView.cellForRow(at: indexPath) as? ItemCell {
      let item = cell.viewModel.model
      let listConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [dbManager, navigator, yourLists, deleteItem] action in
        
        let favoriteItem = UIAction(title: "favorite_item_title".localize(), image: UIImage(systemName: "star.fill"), handler: { [dbManager] action in
          dbManager.updateIsFavorite(isFavorite: true, item: item)
        })
        let unfavoriteItem = UIAction(title: "unfavorite_item_title".localize(), image: UIImage(systemName: "star.slash.fill"), handler: { [dbManager] action in
          dbManager.updateIsFavorite(isFavorite: false, item: item)
        })
        
        let delete = UIAction(title: "delete_list_action".localize(), image: UIImage(systemName: "trash.fill"), attributes: .destructive, handler: { action in
          deleteItem(item, indexPath)
        })
        let edit = UIAction(title: "edit_list_action".localize(), image: UIImage(systemName: "square.and.pencil"), handler: {action in
          navigator.toAddOrEditItem(item: item, forList: item.list, lists: yourLists)
        })
        
        if item.isFavorite {
          return UIMenu(title: "", image: nil, identifier: nil, children: [unfavoriteItem, edit, delete])
        } else {
          return UIMenu(title: "", image: nil, identifier: nil, children: [favoriteItem, edit, delete])
        }
        
      }
      
      return listConfiguration
    }
    return nil
  }
}
