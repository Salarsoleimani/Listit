//  
//  AddItemController.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-06.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

class AddItemController: UIViewController {
  // MARK:- Outlets
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var whichListTextField: UITextField!

  // MARK:- variables
  var parentList: List?
  var lists = [List]()
  var notifDate: Date?
  // MARK:- Constants
  private let navigator: AddItemNavigator
  private let dbManager: DatabaseManagerProtocol

  lazy var listsPickerView: UIPickerView = {
    let pv = UIPickerView()
    pv.dataSource = self
    pv.delegate = self
    return pv
  }()
  // MARK:- variables
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
    
  }
  @IBAction private func saveButtonPressed(_ sender: UIButton) {
    let item = ItemModel(title: titleTextField.text ?? "", notifDate: notifDate, description: descriptionTextView.text, parentList: lists[listsPickerView.tag])
    dbManager.add(Item: item, response: nil)
  }
  // MARK:- Functions
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
    whichListTextField.text = lists[row].title
  }
}
