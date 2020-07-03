//
//  HomeControllerDelegate.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-24.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import Haptico

protocol HomeControllerDelegate: class {
  func listAdded(_ list: List)
}

extension HomeController: HomeControllerDelegate {
  func listAdded(_ list: List) {
    fetchLists()
    if let lists = listsDataSource.frc.fetchedObjects, lists.count - 1 > 0 {
      let row = lists.count - 1
      let index = IndexPath(item: row, section: 0)
      selectedList = lists[row]
      listsCollectionView.selectItem(at: index, animated: true, scrollPosition: .left)
      let listType = lists[row].getListType()
      let predicate = properPredicateFor(ListType: listType, listId: lists[row].id ?? "")
      fetchItems(predicate)
      thereAreItems(listType: listType)
      autoLayoutAddItemButtonUI(listType)
    }
  }
}

extension HomeController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return addQuickItem(textField)
  }
  internal func addQuickItem(_ textField: UITextField) -> Bool {
    if textField == titleItemTextField, let text = textField.text, !text.isEmpty, let selectedList = selectedList {
      let item = ItemModel(title: text, notifDate: nil, repeats: nil, description: nil, parentList: selectedList, state: nil)
      dbManager.addItem(item, allItemsList: allItemsList, withHaptic: true, response: nil)
      titleItemTextField.text = nil
      let listType = selectedList.getListType()
      let listId = selectedList.id ?? ""
      let predicate = properPredicateFor(ListType: listType, listId: listId)
      fetchItems(predicate)
      thereAreItems(listType: listType)
      Haptico.shared().generate(.success)
      return true
    } else {
      navigator.toast(text: "add_quick_item_title_placeholder".localize(), hapticFeedbackType: .error, backgroundColor: Colors.error.value)
      return false
    }
  }
}
