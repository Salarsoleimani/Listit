//  
//  AddItemController.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-06.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import SPPermissions
import SwiftLocalNotification
import GoogleMobileAds

protocol AddItemControllerDelegate: class {
  func didSelectDateAndTime(date: Date, hour: Int, minute: Int, repeatingInterval: RepeatingInterval)
  func deleteReminder()
}

class AddItemController: UIViewController {
  // MARK:- Outlets
  
  @IBOutlet weak var adBannerContainerView: UIView!
  @IBOutlet weak var removeAdButton: UIButton!
  
  @IBOutlet weak var titleContainerView: UIView!
  
  @IBOutlet weak var descriptionLabel: UILabel?
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var moreInfoButton: UIButton!
  @IBOutlet weak var moreInfoTextView: UITextView!
  
  @IBOutlet weak var whichListContainerView: UIView!
  @IBOutlet weak var whichListTitleLabel: UILabel!
  @IBOutlet weak var whichListTextField: UITextField!
  
  @IBOutlet weak var remindMeContainerView: UIView?
  @IBOutlet weak var remindMeTitleLabel: UILabel!
  @IBOutlet weak var remindMeButton: UIButton!
  
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var saveAndAddAnotherButton: UIButton!
  
  // MARK:- variables
  var allItemsList: List?
  var parentList: List? {
    didSet {
      if let parentList = parentList {
        if let title = parentList.title {
          descriptionLabel?.text = String(format: "add_item_description".localize(), title)
        }
        if parentList.type == ListType.note.rawValue  {
          remindMeContainerView?.isHidden = true
        }
      } else {
        remindMeContainerView?.isHidden = false
      }
    }
  }
  
  var lists = [List]()
  var item: Item?
  var notifDate: Date?
  var repeats: RepeatingInterval?
  // MARK:- Constants
  let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
  var rewardedAd: GADRewardedAd?
  var isRewardedAdWatched = false

  private let navigator: AddItemNavigator
  private let dbManager: DatabaseManagerProtocol
  
  lazy var listsPickerView: UIPickerView = {
    let pv = UIPickerView()
    pv.dataSource = self
    pv.delegate = self
    return pv
  }()
  //MARK:- Initialization
  init(navigator: AddItemNavigator, dbManager: DatabaseManagerProtocol) {
    self.navigator = navigator
    self.dbManager = dbManager
    super.init(nibName: "AddItemController", bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK:- LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    if !Defaults.isAdsRemoved {
      setupAds()
    }
    if let parentList = parentList, parentList.type == ListType.note.rawValue {
      remindMeContainerView?.isHidden = true
    }
    whichListTextField.inputView = listsPickerView
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupLocalization()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    titleTextField.becomeFirstResponder()
  }
  // MARK:- Actions
  
  @IBAction private func remindMeButtonPressed(_ sender: UIButton) {
    if !SPPermission.notification.isAuthorized {
      let controller = SPPermissions.dialog([.notification])
      controller.present(on: self)
      return
    }
    if isRewardedAdWatched {
      goToDateSelection()
      isRewardedAdWatched = false
      return
    }
    showRewardedAd()
  }
  
  @IBAction func moreInfoButtonPressed(_ sender: Any) {
    UIView.animate(withDuration: 0.25) { [moreInfoTextView, moreInfoButton] in
      moreInfoTextView?.isHidden = false
      moreInfoButton?.isHidden = true
    }
    moreInfoTextView.becomeFirstResponder()
  }
  @IBAction private func saveAndAddAnotherButtonPressed(_ sender: UIButton) {
    let isValid = validateSave()
    if isValid {
      titleTextField.text = ""
      moreInfoTextView.text = ""
      remindMeButton.setTitle("remind_me_button_title".localize(), for: .normal)
      saveAndAddAnotherButton.setTitle("save_and_another_item_button_title".localize(), for: .normal)
      saveButton.setTitle("save_button_title".localize(), for: .normal)
      navigationItem.title = "add_item_navigation_title".localize()
      
      item = nil
      notifDate = nil
      repeats = nil
    }
  }
  @IBAction private func saveButtonPressed(_ sender: Any?) {
    let isValid = validateSave()
    if isValid {
      navigator.pop()
    }
  }
  // MARK:- Functions
  private func validateSave() -> Bool {
    if let text = titleTextField.text, text.isEmpty {
      navigator.toast(text: "add_title_for_item_error".localize(), hapticFeedbackType: .warning, backgroundColor: Colors.error.value)
      titleTextField.becomeFirstResponder()
      return false
    } else if titleTextField.text == nil {
      navigator.toast(text: "add_title_for_item_error".localize(), hapticFeedbackType: .warning, backgroundColor: Colors.error.value)
      titleTextField.becomeFirstResponder()
      return false
    } else if parentList == nil {
      navigator.toast(text: "select_list_for_item_error".localize(), hapticFeedbackType: .warning, backgroundColor: Colors.error.value)
      whichListTextField.becomeFirstResponder()
      return false
    } else if let parentList = parentList, parentList.type == ListType.countdown.rawValue, notifDate == nil {
      navigator.toast(text: "select_date_for_item_error".localize(), hapticFeedbackType: .warning, backgroundColor: Colors.error.value)
      navigator.toDateSelection(date: nil, repeating: .none, delegate: self)
      return false
    } else {
      saveItem()
      return true
    }
  }
  private func saveItem() {
    if let item = item {
      item.title = titleTextField.text
      item.desc = moreInfoTextView.text
      item.list = parentList
      item.state = ItemState.default.rawValue
      
      if item.notifDate == notifDate, item.repeats == repeats?.rawValue {
        dbManager.update(Item: item, isNotifDateChanged: false, response: nil)
      } else {
        item.repeats = repeats?.rawValue
        item.notifDate = notifDate
        dbManager.update(Item: item, isNotifDateChanged: true, response: nil)
      }
      return
    }
    
    let item = ItemModel(title: titleTextField.text ?? "", notifDate: notifDate, repeats: repeats, description: moreInfoTextView.text, parentList: parentList ?? lists[listsPickerView.tag], state: .doing)
    
    
    dbManager.addItem(item, allItemsList: allItemsList, response: nil)
  }
  func goToDateSelection() {
    if let notifDate = notifDate, let repeats = repeats {
      navigator.toDateSelection(date: notifDate, repeating: repeats, delegate: self)
    } else {
      navigator.toDateSelection(date: nil, repeating: RepeatingInterval.none, delegate: self)
    }
  }
}
extension AddItemController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return lists.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return lists[row].title
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    pickerView.tag = row
    parentList = lists[row]
    whichListTextField.text = lists[row].title
  }
}
extension AddItemController: AddItemControllerDelegate {
  func deleteReminder() {
    notifDate = nil
    repeats = nil
    view.endEditing(true)
    remindMeButton.setTitle("remind_me_button_title".localize(), for: .normal)
  }
  
  func didSelectDateAndTime(date: Date, hour: Int, minute: Int, repeatingInterval: RepeatingInterval) {
    notifDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: date)
    repeats = repeatingInterval
    
    if let rep = repeats, let notifDate = notifDate {
      let formatter = DateFormatter()
      formatter.dateFormat = "YYYY/MMM/dd HH:mm"
      let dateStr = formatter.string(from: notifDate)
      let title = rep != .none ? "\(dateStr) (\(rep.rawValue))": dateStr
      remindMeButton.setTitle(title, for: .normal)
    }
  }
}

extension AddItemController: SPPermissionsDelegate {
  func didAllow(permission: SPPermission) {
    if isRewardedAdWatched {
      goToDateSelection()
      isRewardedAdWatched = false
      return
    }
    showRewardedAd()
  }
}
