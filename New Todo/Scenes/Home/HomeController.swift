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

protocol HomeControllerDelegate: class {
  func listAdded(list: List)
  func listUpdated(list: List)
  func listDeleted(list: List)
  
  func itemAdded(item: Item)
  func itemUpdated(item: Item)
  func itemDeleted(item: Item)
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
  var allLists = [List]()
  var allItems = [Item]()
  var filteredItems = [Item]()

  var selectedList: List?
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
    listsCollectionView.delegate = self
    listsCollectionView.dataSource = self
    
    let itemNib = UINib(nibName: "ItemCell", bundle: nil)
    itemsTableView.register(itemNib, forCellReuseIdentifier: Constants.CellIds.cellId)
    itemsTableView.delegate = self
    itemsTableView.dataSource = self
    
    dbManager.getAllLists { [unowned self, listsCollectionView] (dbLists) in
      self.allLists = dbLists
      listsCollectionView?.reloadData()
    }
    
    dbManager.getAllItems { [unowned self, itemsTableView] (dbItems) in
      self.allItems = dbItems
      self.filteredItems = dbItems
      itemsTableView?.reloadData()
    }
    
  }
  //MARK:- Actions
  @IBAction private func addItemButtonPressed(_ sender: UIButton) {
    let filteredList = allLists.filter { (list) -> Bool in
      let type = ListType(rawValue: list.type) ?? ListType.default
      return type != .all && type != .favorites && type != .today
    }
    if !filteredList.isEmpty {
      navigator.toAddOrEditItem(item: nil, forList: selectedList, lists: filteredList, delegate: self)
    } else {
      navigator.toast(text: "add_item_no_list_error".localize(), hapticFeedbackType: .error, backgroundColor: Colors.error.value)
      navigator.toAddOrEditList(list: nil, delegate: self)
    }
  }
  @IBAction private func addListButtonPressed(_ sender: UIButton) {
    navigator.toAddOrEditList(list: nil, delegate: self)
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
extension HomeController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return allLists.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIds.cellId, for: indexPath) as! ListCell
    cell.bindData(withViewModel: ListItemViewModel(model: allLists[indexPath.item]))
    return cell
  }
}
extension HomeController: UICollectionViewDelegate {
  private func addDataToItemsTableView(data: [Item]) {
    filteredItems = data
    itemsTableView.reloadData()
  }
  private func updateItemsTableView(_ selectedListRow: Int) {
    let listType = ListType(rawValue: allLists[selectedListRow].type) ?? ListType.default
    let filteredItems = allItems.filter{ $0.list == allLists[selectedListRow] }

    switch listType {
    case .reminder:
      addDataToItemsTableView(data: filteredItems)
    case .countdown:
      addDataToItemsTableView(data: filteredItems)
    case .note:
      addDataToItemsTableView(data: filteredItems)
    case .favorites:
      let filteredItems = allItems.filter{ $0.isFavorite }
      addDataToItemsTableView(data: filteredItems)
    case .all:
      addDataToItemsTableView(data: allItems)
    case .today:
      let filteredItems = allItems.filter { (item) -> Bool in
        if let notifDate = item.notifDate {
          return Calendar.current.isDateInToday(notifDate)
        }
        if let repeats = item.repeats, let repeatInterval = RepeatingInterval(rawValue: repeats) {
          return repeatInterval == .daily || repeatInterval == .hourly || repeatInterval == .minute
        }
        return false
      }
      addDataToItemsTableView(data: filteredItems)
    case .none:
      addDataToItemsTableView(data: filteredItems)
    }
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
    navigator.toAddOrEditList(list: allLists[index], delegate: self)
  }
  private func addNewItemAction(_ index: Int) {
    navigator.toAddOrEditItem(item: nil, forList: allLists[index], lists: allLists, delegate: self)
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
    filteredItems.remove(at: indexPath.row)
    itemsTableView.deleteRows(at: [indexPath], with: .left)
  }
  func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    if let cell = tableView.cellForRow(at: indexPath) as? ItemCell {
      let item = cell.viewModel.model
      let listConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [dbManager, navigator, selectedList, allLists, deleteItem] action in
        
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
          navigator.toAddOrEditItem(item: item, forList: selectedList, lists: allLists, delegate: self)
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
extension HomeController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.cellId, for: indexPath) as! ItemCell
    cell.bindData(withViewModel: ItemViewModel(model: filteredItems[indexPath.row]))
    return cell
  }
}
extension HomeController: HomeControllerDelegate {
  func listDeleted(list: List) {
    for (index, allList) in allLists.enumerated() {
      if allList == list {
        deleteList(index)
      }
    }
  }
  
  func listUpdated(list: List) {
    for (index, allList) in allLists.enumerated() {
      if allList.id == list.id {
        allLists[index] = list
        listsCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
      }
    }
  }
  
  func listAdded(list: List) {
    allLists.append(list)
    listsCollectionView.reloadData()
  }
  
  func itemAdded(item: Item) {
    
  }
  
  func itemUpdated(item: Item) {
    
  }
  
  func itemDeleted(item: Item) {
    
  }
}
