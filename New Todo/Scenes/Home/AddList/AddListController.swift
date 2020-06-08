//  
//  AddListController.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import CocoaTextField

protocol AddListControllerDelegate {
  func iconSelected(_ icon: IconCellViewModel)
}
extension AddListController: AddListControllerDelegate {
  func iconSelected(_ icon: IconCellViewModel) {
    iconButton.tintColor = icon.color
    iconButton.setTitle("", for: .normal)
    iconButton.setImage(icon.image, for: .normal)
  }
}
class AddListController: UIViewController {
  // MARK:- Outlets
  @IBOutlet weak var containerView: UIView!

  @IBOutlet weak var iconButton: UIButton!
  @IBOutlet weak var iconContainerView: UIView!
  @IBOutlet weak var titleTextField: CocoaTextField!
  @IBOutlet weak var itemsQtyLabel: UILabel!
  // MARK:- variables
  var list: List?
  // MARK:- Constants
  private let navigator: AddListNavigator
  private let dbManager: DatabaseManagerProtocol
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
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    titleTextField.becomeFirstResponder()
  }
  // MARK:- Actions
  @IBAction private func didTapIcon(_ sender: UIButton) {
    navigator.toIconSelector(delegate: self)
  }
  // MARK:- Functions
}
