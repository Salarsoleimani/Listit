//
//  HomeController.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-01.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import BEKListKit
import CoreData

protocol HomeControllerDelegate: class {
  func listAdded(list: List)
  func itemAdded(item: Item)
}
class HomeController: UIViewController {
  //MARK:- Outlets
  @IBOutlet weak var itemsTableView: BEKMultiCellTable!
  @IBOutlet weak var googleAdView: UIView!
  @IBOutlet weak var listsCollectionView: BEKMultiCellCollection!
  
  //MARK:- Constants
  private let navigator: HomeNavigator
  private let dbManager: DatabaseManagerProtocol
  //MARK:- Variables
  var lists = [List]()
  var allItems = [Item]()
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
    let addListCell = BEKGenericCell.Collection<AddListCell>(viewModel: "")
    listsCollectionView.push(cell: addListCell)
    listsCollectionView.delegate = self
    
    
    let listNameTemplatesVM = [ItemsShowTypes.all, .favorites, .today]
    for listName in listNameTemplatesVM {
      let listNameCell = BEKGenericCell.Collection<ListNameCell>(viewModel: listName.text())
      listsCollectionView.push(cell: listNameCell)
    }
    
    dbManager.getAllLists { [unowned self] (dbLists) in
      self.lists = dbLists
      for list in dbLists {
        let listVM = ListItemViewModel(model: list)
        let listCell = BEKGenericCell.Collection<ListCell>(viewModel: listVM)
        self.listsCollectionView.push(cell: listCell)
      }
    }
    dbManager.getAllItems { [unowned self] (dbItems) in
      self.allItems = dbItems
      for item in dbItems {
        let itemVM = ItemViewModel(model: item)
        let itemCell = BEKGenericCell.Table<ItemCell>(viewModel: itemVM)
        self.itemsTableView.push(cell: itemCell)
      }
    }
    
  }
  //MARK:- Actions
  @IBAction private func addItemButtonPressed(_ sender: UIButton) {
    navigator.toAddItem(forList: selectedList, lists: lists)
  }
}
extension HomeController: UICollectionViewDelegate {
  private func addDataToItemsTableView(data: [Item]) {
    itemsTableView.removeAll()
    for item in data {
      let itemVM = ItemViewModel(model: item)
      let itemCell = BEKGenericCell.Table<ItemCell>(viewModel: itemVM)
      self.itemsTableView.push(cell: itemCell)
    }
    itemsTableView.reloadData()
  }
  private func updateItemsTableView(_ selectedListRow: Int) {
    // My lists
    let index = selectedListRow - 4
    if index >= 0, index < lists.count {
      let filteredItems = allItems.filter{ $0.list == lists[index] }
      addDataToItemsTableView(data: filteredItems)
    }
    // Template lists
    switch selectedListRow {
    case 1:
      // All items selected
      addDataToItemsTableView(data: allItems)
    case 2:
      // Favorites items selected
      let filteredItems = allItems.filter{ $0.isFavorite }
      addDataToItemsTableView(data: filteredItems)
    case 3:
      // Today items selected
      let filteredItems = allItems.filter { (item) -> Bool in
        if let notifDate = item.notifDate {
          return Calendar.current.isDateInToday(notifDate)
        }
        return false
      }
      addDataToItemsTableView(data: filteredItems)
    default:
      print("row number: \(selectedListRow) selected")
    }
  }
  
  private func listSelected(_ row: Int) {
    let index = row - 4
    if index >= 0, index < lists.count {
      selectedList = lists[index]
      navigationItem.title = lists[index].title ?? ""
    }
    
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.item == 0, collectionView == listsCollectionView {
      navigator.toAddList()
    } else if collectionView == listsCollectionView {
      listSelected(indexPath.item)
      updateItemsTableView(indexPath.item)
    }
  }
  func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    
    let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { action in
      
      let addItem = UIAction(title: "Add new \(self.lists[indexPath.item].title ?? "")", image: UIImage(systemName: "plus.square"), handler: {action in
        print("rotate clicked.")
      })
      
      let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), attributes: .destructive, handler: {action in
        
        print("delete clicked.")
      })
      let edit = UIAction(title: "Edit...", image: UIImage(systemName: "square.and.pencil"), handler: {action in
        
        print("delete clicked.")
      })
      
      return UIMenu(title: "", image: nil, identifier: nil, children: [addItem, edit, delete])
    }
    
    return configuration
  }
}
extension HomeController: UITableViewDelegate {
}
