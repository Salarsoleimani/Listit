////  
////  AddListController.swift
////  Listit
////
////  Created by Salar Soleimani on 2020-06-03.
////  Copyright © 2020 ssmobileapps.com All rights reserved.
////
//
//import UIKit
//import GoogleMobileAds
//
//
//class AddListController: UIViewController {
//  // MARK:- Outlets
//  @IBOutlet weak var adBannerContainerView: UIView!
//  @IBOutlet weak var removeAdButton: UIButton!
//  
//  @IBOutlet weak var containerView: UIView!
//  
//  @IBOutlet weak var iconButton: UIButton!
//  @IBOutlet weak var iconContainerView: UIView!
//  @IBOutlet weak var titleTextField: UITextField!
//  @IBOutlet weak var editIconLabel: UILabel!
//
//  @IBOutlet weak var listTypeContainerView: UIView!
//  
//  @IBOutlet weak var listTypeTitleLabel: UILabel!
//  @IBOutlet weak var listTypeSegmentedControl: UISegmentedControl!
//  
//  @IBOutlet weak var saveButton: UIButton!
//  
////  lazy var listTypesPickerView: UIPickerView = {
////    let pv = UIPickerView()
////    pv.dataSource = self
////    pv.delegate = self
////    return pv
////  }()
//  
//  // MARK:- variables
//  var delegate: HomeControllerDelegate?
//  var list: List?
//  var listModel = ListModel(iconColor: Constants.Defaults.color, iconId: 0, iconName: "ic_0", itemsCount: 0, title: "", type: 1)
//  
//  let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//  var rewardedAd: GADRewardedAd?
//  var isRewardedAdWatched = false
//  
//  // MARK:- Constants
//  private let navigator: AddListNavigator
//  private let dbManager: DatabaseManagerProtocol
//  private let disposeBag = DisposeBag()
//  
//  //MARK:- Initialization
//  init(navigator: AddListNavigator, dbManager: DatabaseManagerProtocol) {
//    self.navigator = navigator
//    self.dbManager = dbManager
//    super.init(nibName: "AddListController", bundle: nil)
//  }
//  
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  // MARK:- LifeCycles
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    setupUI()
//    if !Defaults.isAdsRemoved {
//      setupAds()
//    }
//    if list == nil {
//      randomizeIconColor()
//      randomizeIconImage()
//    } else {
//      setupNavigationButtons()
//    }
//    
//    observeOnTitleChange()
//  }
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(true)
//    setupLocalization()
//    isAdsRemoved()
//  }
//  override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//    titleTextField.becomeFirstResponder()
//  }
//  // MARK:- Actions
//  @IBAction private func didTapIcon(_ sender: UIButton) {
//    if isRewardedAdWatched {
//      navigator.toIconSelector(delegate: self, listTitle: list?.title ?? listModel.title)
//      if !Defaults.isAdsRemoved {
//        isRewardedAdWatched = false
//      }
//      return
//    }
//    showRewardedAd()
//  }
//  @IBAction private func didTapSaveButton(_ sender: UIButton) {
//    if let text = titleTextField.text, text.isEmpty {
//      navigator.toast(text: "add_title_for_list_error".localize(), hapticFeedbackType: .error, backgroundColor: Colors.error.value)
//      titleTextField.becomeFirstResponder()
//    } else if titleTextField.text == nil {
//      navigator.toast(text: "add_title_for_list_error".localize(), hapticFeedbackType: .error, backgroundColor: Colors.error.value)
//      titleTextField.becomeFirstResponder()
//    } else {
//      saveList()
//    }
//  }
//  
//  @IBAction private func removeAdsButtonPressed(_ sender: UIButton) {
//    navigator.toSetting()
//  }
//  @IBAction private func listTypeSegmentControlValueChanged(_ sender: UISegmentedControl) {
//    switch sender.selectedSegmentIndex {
//    case 0:
//      listModel.type = 1
//    case 1:
//      listModel.type = 2
//    case 2:
//      listModel.type = 3
//    default:
//      print("Used undefined segment index for list")
//    }
//  }
//  // MARK:- Functions
//  private func isAdsRemoved() {
//    if Defaults.isAdsRemoved {
//      adBannerContainerView.isHidden = true
//      isRewardedAdWatched = true
//    } else {
//      adBannerContainerView.isHidden = false
//    }
//  }
//  private func saveList() {
//    if let list = list {
//      list.iconColor = listModel.iconColor
//      list.iconId = listModel.iconId
//      list.iconName = listModel.iconName
//      list.title = listModel.title
//      list.type = listModel.type
//      
//      dbManager.update(List: list, response: nil)
//      navigator.pop()
//      return
//    }
//    let list = dbManager.addList(listModel, withHaptic: true, response: nil)
//    delegate?.listAdded(list)
//    navigator.pop()
//  }
//  
//  private func setupNavigationButtons() {
//    let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteButtonPressed))
//    navigationItem.rightBarButtonItems = [rightBarButton]
//  }
//  
//  @objc private func deleteButtonPressed() {
//    view.endEditing(true)
//    let cancelAction = UIAlertAction(title: "cancel_list_action".localize(), style: .cancel)
//    let deleteAction = UIAlertAction(title: "delete_list_action".localize(), style: .destructive) { [dbManager, list, navigator] (action) in
//      if let list = list {
//        dbManager.delete(List: list, response: nil)
//        navigator.pop()
//      }
//    }
//    let listTitle = list?.title ?? ""
//    let deleteListTitleAlert = String(format: "delete_list_title_alert".localize(), listTitle)
//    let deleteListDescAlert = String(format: "delete_list_desc_alert".localize(), arguments: [listTitle, listTitle])
//    let alertt = navigator.simpleAlert(title: deleteListTitleAlert, message: deleteListDescAlert, actions: [cancelAction, deleteAction])
//    present(alertt, animated: true, completion: nil)
//  }
//  private func observeOnTitleChange() {
//    titleTextField.rx.text.orEmpty.subscribe(onNext: { [unowned self] (text) in
//      self.listModel.title = text
//    }).disposed(by: disposeBag)
//  }
//  private func randomizeIconColor() {
//    let colors = SSMocker<ColorModel>.loadGenericObjectsFromLocalJson(fileName: "Colors")
//    if let randomColor = colors.randomElement() {
//      iconContainerView.backgroundColor = randomColor.getColor()
//      listModel.iconColor = randomColor.value
//    }
//  }
//  private func randomizeIconImage() {
//    let icons = SSMocker<IconModel>.loadGenericObjectsFromLocalJson(fileName: "Icons")
//    if let randomIcon = icons.randomElement() {
//      iconButton.setImage(randomIcon.getImage(), for: .normal)
//      listModel.iconId = Int16(randomIcon.id)
//      listModel.iconName = "ic_\(randomIcon.id)"
//    }
//  }
//}
