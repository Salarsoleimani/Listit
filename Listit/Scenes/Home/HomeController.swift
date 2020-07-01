//
//  HomeController.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-01.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds
import Haptico

class HomeController: UIViewController {
  //MARK:- Outlets
  @IBOutlet weak var adBannerContainerView: UIView!
  @IBOutlet weak var removeAdButton: UIButton!

  @IBOutlet weak var itemsTableView: UITableView!
  
  @IBOutlet weak var listsCollectionView: UICollectionView!
  
  @IBOutlet weak var addItembuttonContainerView: UIView!
  @IBOutlet weak var addItemLabel: UILabelX!
  @IBOutlet weak var addItemButton: UIButton!
  @IBOutlet weak var addListButton: UIButton!
  @IBOutlet weak var addListLabel: UILabelX!
  
  @IBOutlet weak var addMoreDetailForItemButton: UIButton!
  @IBOutlet weak var titleItemTextField: UITextField!
  @IBOutlet weak var titleItemContainerView: UIView!
  @IBOutlet weak var titleItemContainerViewBottomAnchor: NSLayoutConstraint!

  @IBOutlet weak var noItemsStackView: UIStackView!
  @IBOutlet weak var noItemsLabel: UILabel!
  @IBOutlet weak var noItemsImageView: UIImageView!

  let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
  var rewardedAd: GADRewardedAd?

  //MARK:- Constants
  internal let navigator: HomeNavigator
  internal let dbManager: DatabaseManagerProtocol
  internal var itemsDataSource: ItemsTableViewDataSource!
  internal var listsDataSource: ListsCollectionViewDataSource!
  
  //MARK:- Variables
  internal lazy var allItemsList = listsDataSource.frc.fetchedObjects?.filter{$0.type == ListType.all.rawValue}.first
  internal lazy var favoriteList = listsDataSource.frc.fetchedObjects?.filter{$0.type == ListType.favorites.rawValue}.first
  var allLists = [List]()
  
  var yourLists = [List]()
  var selecteItemIndexpaths = [IndexPath]()
  var selectedList: List? {
    didSet {
      selecteItemIndexpaths.removeAll()
      navigationItem.title = selectedList?.title ?? ""
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
    
    registerCells()
    
    configureItemsDataSource()
    configureListsDataSource()
    
    if !Defaults.isAdsRemoved {
      setupAds()
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setLocalization()
    isAdsRemoved()
  }
  private func isAdsRemoved() {
    if Defaults.isAdsRemoved {
      adBannerContainerView.isHidden = true
    } else {
      adBannerContainerView.isHidden = false
    }
  }
  //MARK:- Actions
  @IBAction private func addItemButtonPressed(_ sender: UIButton) {
    if sender.tag == 0 {
      addList()
      return
    }
    quickAddList()
  }
  
  @IBAction private func addListButtonPressed(_ sender: UIButton) {
    navigator.toAddOrEditList(list: nil, delegate: self)
  }
  @IBAction private func removeAdsButtonPressed(_ sender: UIButton) {
    navigator.toSetting()
  }
  @IBAction private func addMoreDetailForItemButtonPressed(_ sender: UIButton) {
    view.endEditing(true)
    titleItemTextField.text = ""
    navigator.toAddOrEditItem(item: nil, forList: selectedList, lists: allLists, allItemsList: allItemsList, itemTitle: titleItemTextField.text ?? "")
  }
  internal func quickAddList() {
    if let selectedList = selectedList, selectedList.type != ListType.all.rawValue, selectedList.type != ListType.favorites.rawValue {
      titleItemTextField.becomeFirstResponder()
      Haptico.shared().generate(.light)
    } else {
      navigator.toast(text: "select_list_for_item_error".localize(), hapticFeedbackType: .error, backgroundColor: Colors.error.value)
    }
  }
  internal func addList() {
    if !yourLists.isEmpty {
      navigator.toAddOrEditItem(item: nil, forList: selectedList, lists: yourLists, allItemsList: allItemsList)
    } else {
      navigator.toast(text: "add_item_no_list_error".localize(), hapticFeedbackType: .error, backgroundColor: Colors.error.value)
      navigator.toAddOrEditList(list: nil, delegate: self)
    }
  }
  @objc private func settingButtonPressed() {
    navigator.toSetting()
  }
  //MARK:- Functions
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
       UIView.animate(withDuration: 0.5) { [titleItemContainerView, titleItemContainerViewBottomAnchor, titleItemTextField] in
         titleItemContainerViewBottomAnchor?.constant = -132
        titleItemTextField?.text = ""
        titleItemContainerView?.layoutIfNeeded()
       }
     } else {
       UIView.animate(withDuration: 0.5) { [titleItemContainerView, titleItemContainerViewBottomAnchor] in
         titleItemContainerViewBottomAnchor?.constant = keyboardViewEndFrame.height - 20
         titleItemContainerView?.layoutIfNeeded()
       }
     }
   }
  
  private func setupNavigationButtons() {
    let rightBarButton = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(settingButtonPressed))
    navigationItem.rightBarButtonItems = [rightBarButton]
  }
 
}

