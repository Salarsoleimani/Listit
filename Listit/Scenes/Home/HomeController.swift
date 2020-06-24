//
//  HomeController.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-01.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import CoreData
import Haptico
import GoogleMobileAds

class HomeController: UIViewController {
  //MARK:- Outlets
  @IBOutlet weak var adBannerContainerView: UIView!
  @IBOutlet weak var removeAdButton: UIButton!
  @IBOutlet weak var adBannerContainerViewHeightAnchor: NSLayoutConstraint!

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

  let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
  var rewardedAd: GADRewardedAd?

  //MARK:- Constants
  internal let navigator: HomeNavigator
  internal let dbManager: DatabaseManagerProtocol
  internal var itemsDataSource: ItemsCollectionViewDataSource!
  internal var listsDataSource: ListsCollectionViewDataSource!
  
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
  var selecteItemIndexpaths = [IndexPath]()
  var selectedList: List? {
    didSet {
      selecteItemIndexpaths.removeAll()
    }
  }
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
    setupKeyboardObserver()
    
    registerCollectionViewCells()
    configureCollectionViewsDelegate()
    
    configureListsDataSource()
    configureItemsDataSource()
    
    setupAds()
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
  func configureCollectionViewsDelegate() {
    listsCollectionView.delegate = self
    itemsCollectionView.delegate = self
  }
  private func setupKeyboardObserver() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    titleItemTextField.delegate = self
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
         titleItemContainerViewBottomAnchor?.constant = keyboardViewEndFrame.height - 20
         view?.layoutIfNeeded()
       }
     }
   }
  
  private func setupNavigationButtons() {
    let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingButtonPressed))
    navigationItem.rightBarButtonItems = [rightBarButton]
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
