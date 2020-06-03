//
//  HomeController.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-01.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
//MARK:- Outlets

//MARK:- Constants
  private let navigator: HomeNavigator
  private let dbManager: DatabaseManagerProtocol
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
  }
//MARK:- Actions

}

