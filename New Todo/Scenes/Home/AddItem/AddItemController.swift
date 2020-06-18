//  
//  AddItemController.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-06.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import SwiftLocalNotification

protocol AddItemControllerDelegate: class {
  func didSelectDateAndTime(date: Date, hour: Int, minute: Int, repeatingInterval: RepeatingInterval)
  func deleteReminder()
}

class AddItemController: UIViewController {
  // MARK:- Outlets
  @IBOutlet weak var titleContainerView: UIView!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var moreInfoButton: UIButton!
  @IBOutlet weak var moreInfoTextView: UITextView!
  
  @IBOutlet weak var whichListContainerView: UIView!
  @IBOutlet weak var whichListTitleLabel: UILabel!
  @IBOutlet weak var whichListTextField: UITextField!
  
  @IBOutlet weak var remindMeContainerView: UIView!
  @IBOutlet weak var remindMeTitleLabel: UILabel!
  @IBOutlet weak var remindMeButton: UIButton!
  
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var saveAndAddAnotherButton: UIButton!
  
  // MARK:- variables
  var parentList: List?
  var lists = [List]()
  var item: Item?
  var notifDate: Date?
  var repeats: RepeatingInterval?
  var delegate: HomeControllerDelegate?
  // MARK:- Constants
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
    
    whichListTextField.inputView = listsPickerView
  }
  // MARK:- Actions
  
  @IBAction private func remindMeButtonPressed(_ sender: UIButton) {
    if let notifDate = item?.notifDate, let repeats = item?.repeats {
      let repeatsInterval = RepeatingInterval(rawValue: repeats) ?? RepeatingInterval.none
      navigator.toDateSelection(date: notifDate, repeating: repeatsInterval, delegate: self)
    } else {
      navigator.toDateSelection(date: nil, repeating: RepeatingInterval.none, delegate: self)
    }
  }
  
  @IBAction func moreInfoButtonPressed(_ sender: Any) {
    UIView.animate(withDuration: 0.25) { [moreInfoTextView, moreInfoButton] in
      moreInfoTextView?.isHidden = false
      moreInfoButton?.isHidden = true
    }
  }
  @IBAction private func saveAndAddAnotherButtonPressed(_ sender: UIButton) {
    
  }
  @IBAction private func saveButtonPressed(_ sender: UIButton) {
    if let text = titleTextField.text, text.isEmpty {
      navigator.toast(text: "add_title_for_list_error".localize(), hapticFeedbackType: .warning, backgroundColor: Colors.error.value)
      titleTextField.becomeFirstResponder()
    } else if titleTextField.text == nil {
      navigator.toast(text: "add_title_for_list_error".localize(), hapticFeedbackType: .warning, backgroundColor: Colors.error.value)
      titleTextField.becomeFirstResponder()
    } else if parentList == nil {
      navigator.toast(text: "select_type_for_list_error".localize(), hapticFeedbackType: .warning, backgroundColor: Colors.error.value)
      whichListTextField.becomeFirstResponder()
    } else {
      saveItem()
    }
  }
  // MARK:- Functions
  private func saveItem() {
    if let item = item {
      item.title = titleTextField.text
      item.desc = moreInfoTextView.text
      item.repeats = repeats?.rawValue
      item.notifDate = notifDate
      item.list = parentList
      
      dbManager.update(Item: item, response: nil)
      delegate?.itemUpdated(item: item)
      navigator.pop()
      return
    }
    let item = ItemModel(title: titleTextField.text ?? "", notifDate: notifDate, repeats: repeats, description: moreInfoTextView.text, parentList: parentList ?? lists[listsPickerView.tag])
    let dbItem = dbManager.addItem(item, response: nil)
    delegate?.itemAdded(item: dbItem)
    navigator.pop()
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
