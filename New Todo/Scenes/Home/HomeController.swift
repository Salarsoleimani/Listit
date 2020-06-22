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
import Haptico

fileprivate class ListsCollectionViewDataSource: FRCCollectionViewDataSource<List> {
  
}
extension HomeController: FRCCollectionViewDelegate {
  func frcCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIds.cellId, for: indexPath) as! ListCell
    let list = listsDataSource.object(at: indexPath)
    cell.bindData(withViewModel: ListItemViewModel(model: list))

    if list.type == ListType.all.rawValue {
      let allItemsCount = itemsDataSource.frc.fetchedObjects?.count ?? 0
      cell.itemsQtyLabel.text = "\(allItemsCount) \("all_lists_type_quantity".localize())"
    } else if list.type == ListType.favorites.rawValue {
      let favItemsCount = itemsDataSource.frc.fetchedObjects?.filter{$0.isFavorite}.count ?? 0
      cell.itemsQtyLabel.text = "\(favItemsCount) \("favorites_lists_type_quantity".localize())"
    }
    return cell
  }
}
fileprivate class ItemsCollectionViewDataSource: FRCItemsCollectionDataSource<Item> {
  
  
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

class HomeController: UIViewController {
  //MARK:- Outlets
  @IBOutlet weak var itemsCollectionView: UICollectionView!
  @IBOutlet weak var listsCollectionView: UICollectionView!
  
  @IBOutlet weak var addItemLabel: UILabelX!
  @IBOutlet weak var addItemButton: UIButton!
  @IBOutlet weak var addListButton: UIButton!
  @IBOutlet weak var addListLabel: UILabelX!
  
  @IBOutlet weak var quickAddItembuttonContainerView: UIView!
  @IBOutlet weak var quickAddItemLabel: UILabelX!
  @IBOutlet weak var quickAddItemButton: UIButton!
  
  @IBOutlet weak var titleItemTextField: UITextField!
  @IBOutlet weak var titleItemContainerView: UIView!
  @IBOutlet weak var titleItemContainerViewBottomAnchor: NSLayoutConstraint!

  //MARK:- Constants
  private let navigator: HomeNavigator
  private let dbManager: DatabaseManagerProtocol
  //MARK:- Variables
  lazy var allLists: [List] = {
    listsDataSource.performFetch()
    return listsDataSource.frc.fetchedObjects ?? [List]()
  }()
  
  lazy var yourLists: [List] = {
    let filteredList = allLists.filter { (list) -> Bool in
      let type = ListType(rawValue: list.type) ?? ListType.default
      return type != .all && type != .favorites
    }
    return filteredList
  }()
    
  var selectedList: List?
  private var itemsDataSource: ItemsCollectionViewDataSource!
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
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    titleItemTextField.delegate = self
    
    let listNib = UINib(nibName: "ListCell", bundle: nil)
    listsCollectionView.register(listNib, forCellWithReuseIdentifier: Constants.CellIds.cellId)
    let listsFetchRequest: NSFetchRequest<List> = List.fetchRequest()
    listsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
    listsFetchRequest.fetchBatchSize = 20
    listsDataSource = ListsCollectionViewDataSource(fetchRequest: listsFetchRequest, context: CoreDataStack.managedContext, sectionNameKeyPath: nil, delegate: self, collectionView: listsCollectionView)
    
    listsCollectionView.dataSource = listsDataSource
    listsCollectionView.delegate = self
    listsDataSource.performFetch()

    let itemNib = UINib(nibName: "ItemCell", bundle: nil)
    itemsCollectionView.register(itemNib, forCellWithReuseIdentifier: Constants.CellIds.cellId)
    
    let itemsFetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    itemsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
    itemsFetchRequest.fetchBatchSize = 20

    itemsDataSource = ItemsCollectionViewDataSource(fetchRequest: itemsFetchRequest, context: CoreDataStack.managedContext, sectionNameKeyPath: nil, delegate: self, collectionView: itemsCollectionView)
    itemsCollectionView.dataSource = itemsDataSource
    itemsCollectionView.delegate = self
    itemsDataSource.performFetch()
    
  }
  //MARK:- Actions
  @IBAction private func addItemButtonPressed(_ sender: UIButton) {
    if !yourLists.isEmpty {
      let allItemsList = listsDataSource.frc.fetchedObjects?.filter{$0.type == ListType.all.rawValue}.first
      navigator.toAddOrEditItem(item: nil, forList: selectedList, lists: yourLists, allItemsList: allItemsList)
    } else {
      navigator.toast(text: "add_item_no_list_error".localize(), hapticFeedbackType: .error, backgroundColor: Colors.error.value)
      navigator.toAddOrEditList(list: nil)
    }
  }
  
  @IBAction private func addListButtonPressed(_ sender: UIButton) {
    navigator.toAddOrEditList(list: nil)
  }
  
  @IBAction private func quickAddListButtonPressed(_ sender: Any) {
    if let selectedList = selectedList, selectedList.type != ListType.all.rawValue, selectedList.type != ListType.favorites.rawValue {
      titleItemTextField.becomeFirstResponder()
    } else {
      navigator.toast(text: "select_list_for_item_error".localize(), hapticFeedbackType: .error, backgroundColor: Colors.error.value)
    }
  }
  
  @objc private func settingButtonPressed() {
    
  }
  //MARK:- Functions
  private func setupNavigationButtons() {
    let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingButtonPressed))
    navigationItem.rightBarButtonItems = [rightBarButton]
  }
  @objc private func adjustForKeyboard(notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    
    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      UIView.animate(withDuration: 0.5) { [view, titleItemContainerViewBottomAnchor] in
        titleItemContainerViewBottomAnchor?.constant = -102
        view?.layoutIfNeeded()
      }
    } else {
      UIView.animate(withDuration: 0.5) { [view, titleItemContainerViewBottomAnchor] in
        titleItemContainerViewBottomAnchor?.constant = keyboardViewEndFrame.height - 26
        view?.layoutIfNeeded()
      }
    }
  }
}

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
    itemsCollectionView.reloadData()
  }
  
  private func listSelected(_ list: List, selectedItem: Int) {
    selectedList = list
    navigationItem.title = list.title ?? ""
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
    if collectionView == listsCollectionView, let listCell = collectionView.cellForItem(at: indexPath) as? ListCell {
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
    } else if collectionView == itemsCollectionView, let cell = collectionView.cellForItem(at: indexPath) as? ItemCell {
      let item = cell.viewModel.model
      let listConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [dbManager, navigator, yourLists, deleteItem, listsDataSource] action in
        
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
  private func deleteItem(_ item: Item, indexPath: IndexPath) {
    dbManager.delete(Item: item, response: nil)
  }
  private func editListAction(_ list: List) {
    navigator.toAddOrEditList(list: list)
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
extension HomeController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == listsCollectionView {
      let listHeight = 150
      return CGSize(width: 150, height: listHeight)
    }
    let itemsCVWidth = itemsCollectionView.frame.width
    var height: CGFloat = 50
    let items = itemsDataSource.frc.fetchedObjects
    if let items = items, indexPath.row < items.count {
      let specificItem = items[indexPath.row]
      let itemListType = ListType(rawValue: specificItem.list?.type ?? ListType.default.rawValue) ?? ListType.default
      switch itemListType {
      case .reminder:
        height =  92
      case .note:
        height = 72
      case .countdown:
        height = 132
      default: break
      }
      if let desc = specificItem.desc, !desc.isEmpty {} else {height -= 12}
    }
    return CGSize(width: itemsCVWidth, height: height)
    
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
  }
}

extension HomeController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == titleItemTextField, let text = textField.text, !text.isEmpty, let selectedList = selectedList {
      let item = ItemModel(title: text, notifDate: nil, repeats: nil, description: nil, parentList: selectedList, state: nil)
      let allItemsList = listsDataSource.frc.fetchedObjects?.filter{$0.type == ListType.all.rawValue}.first

      dbManager.addItem(item, allItemsList: allItemsList, response: nil)
      titleItemTextField.text = nil
      Haptico.shared().generate(.success)
      return true
    } else {
      navigator.toast(text: "add_quick_item_title_placeholder".localize(), hapticFeedbackType: .error, backgroundColor: Colors.error.value)
    }
    return false
  }
}
