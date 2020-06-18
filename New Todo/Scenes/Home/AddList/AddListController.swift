//  
//  AddListController.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import RxSwift

protocol AddListControllerDelegate {
  func iconSelected(_ icon: IconCellViewModel)
}
extension AddListController: AddListControllerDelegate {
  func iconSelected(_ icon: IconCellViewModel) {
    listModel.iconName = "ic_\(icon.model.id)"
    listModel.iconId = Int16(icon.model.id)
    listModel.iconColor = icon.colorModel.value
    
    iconButton.setTitle("", for: .normal)
    iconButton.setImage(icon.image, for: .normal)
    iconContainerView.backgroundColor = icon.color
  }
}
class AddListController: UIViewController {
  // MARK:- Outlets
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var iconButton: UIButton!
  @IBOutlet weak var iconContainerView: UIView!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var itemsQtyLabel: UILabel!
  
  @IBOutlet weak var listTypeContainerView: UIView!
  
  @IBOutlet weak var listTypeTitleLabel: UILabel!
  
  @IBOutlet weak var listTypeTextField: UITextField!
  
  @IBOutlet weak var saveButton: UIButton!
  
  lazy var listTypesPickerView: UIPickerView = {
    let pv = UIPickerView()
    pv.dataSource = self
    pv.delegate = self
    return pv
  }()
  
  // MARK:- variables
  var list: List?
  var listModel = ListModel(iconColor: Constants.Defaults.color, iconId: 0, iconName: "ic_0", itemsCount: 0, title: "", type: 0)
  var listTypes = [ListType.reminder, .countdown, .note]
  // MARK:- Constants
  private let navigator: AddListNavigator
  private let dbManager: DatabaseManagerProtocol
  private let disposeBag = DisposeBag()
  
  //MARK:- Initialization
  init(navigator: AddListNavigator, dbManager: DatabaseManagerProtocol) {
    self.navigator = navigator
    self.dbManager = dbManager
    super.init(nibName: "AddListController", bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK:- LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    
    if list == nil {
      randomizeIconColor()
      randomizeIconImage()
    } else {
      setupNavigationButtons()
    }
    
    observeOnTitleChange()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    titleTextField.becomeFirstResponder()
  }
  // MARK:- Actions
  @IBAction private func didTapIcon(_ sender: UIButton) {
    navigator.toIconSelector(delegate: self, listTitle: list?.title ?? listModel.title)
  }
  @IBAction private func didTapSaveButton(_ sender: UIButton) {
    if let text = titleTextField.text, text.isEmpty {
      navigator.toast(text: "add_title_for_list_error".localize(), hapticFeedbackType: .warning, backgroundColor: Colors.error.value)
      titleTextField.becomeFirstResponder()
    } else if titleTextField.text == nil {
      navigator.toast(text: "add_title_for_list_error".localize(), hapticFeedbackType: .warning, backgroundColor: Colors.error.value)
      titleTextField.becomeFirstResponder()
    } else if listModel.type == 0 {
      navigator.toast(text: "select_type_for_list_error".localize(), hapticFeedbackType: .warning, backgroundColor: Colors.error.value)
      listTypeButtonPressed(0)
    } else {
      saveList()
    }
  }
  @IBAction func listTypeButtonPressed(_ sender: Any) {
    listTypeTextField.inputView = listTypesPickerView
    listTypeTextField.becomeFirstResponder()
  }
  
  // MARK:- Functions
  private func saveList() {
    if let list = list {
      list.iconColor = listModel.iconColor
      list.iconId = listModel.iconId
      list.iconName = listModel.iconName
      list.title = listModel.title
      list.type = listModel.type
      
      dbManager.update(List: list, response: nil)
      navigator.pop()
      return
    }
    dbManager.addList(listModel, response: nil)
    navigator.pop()
  }
  
  private func setupNavigationButtons() {
    let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteButtonPressed))
    navigationItem.rightBarButtonItems = [rightBarButton]
  }
  
  @objc private func deleteButtonPressed() {
    view.endEditing(true)
    let cancelAction = UIAlertAction(title: "cancel_list_action".localize(), style: .cancel)
    let deleteAction = UIAlertAction(title: "delete_list_action".localize(), style: .destructive) { [dbManager, list, navigator] (action) in
      if let list = list {
        dbManager.delete(List: list, response: nil)
        navigator.pop()
      }
    }
    let listTitle = list?.title ?? ""
    let deleteListTitleAlert = String(format: "delete_list_title_alert".localize(), listTitle)
    let deleteListDescAlert = String(format: "delete_list_desc_alert".localize(), arguments: [listTitle, listTitle])
    let alertt = navigator.simpleAlert(title: deleteListTitleAlert, message: deleteListDescAlert, actions: [cancelAction, deleteAction])
    present(alertt, animated: true, completion: nil)
  }
  private func observeOnTitleChange() {
    titleTextField.rx.text.orEmpty.subscribe(onNext: { [unowned self] (text) in
      self.listModel.title = text
    }).disposed(by: disposeBag)
  }
  private func randomizeIconColor() {
    let colors = SSMocker<ColorModel>.loadGenericObjectsFromLocalJson(fileName: "Colors")
    if let randomColor = colors.randomElement() {
      iconContainerView.backgroundColor = randomColor.getColor()
      listModel.iconColor = randomColor.value
    }
  }
  private func randomizeIconImage() {
    let icons = SSMocker<IconModel>.loadGenericObjectsFromLocalJson(fileName: "Icons")
    if let randomIcon = icons.randomElement() {
      iconButton.setImage(randomIcon.getImage(), for: .normal)
      listModel.iconId = Int16(randomIcon.id)
      listModel.iconName = "ic_\(randomIcon.id)"
    }
  }
}
extension AddListController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return listTypes.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return listTypes[row].title()
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    pickerView.tag = row
    listTypeTextField.text = listTypes[row].title()
    listModel.type = listTypes[row].rawValue
    view.endEditing(true)
  }
}
