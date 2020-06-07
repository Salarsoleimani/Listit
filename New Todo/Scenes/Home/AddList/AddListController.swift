//  
//  AddListController.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
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
  // MARK:- Outlets
  @IBOutlet weak var iconButton: UIButton!
  @IBOutlet weak var iconContainerView: UIView!
  @IBOutlet weak var titleTextField: UITextField!
  // MARK:- variables
  private let navigator: AddListNavigator
  private let dbManager: DatabaseManagerProtocol
  // MARK:- Constants
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
  // MARK:- Actions
  @IBAction private func didTapIcon(_ sender: UIButton) {
    navigator.toIconSelector(delegate: self)
  }
  // MARK:- Functions
}
