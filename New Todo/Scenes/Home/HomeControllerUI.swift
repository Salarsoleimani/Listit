//
//  HomeControllerUI.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

extension HomeController {
  func setupUI() {
    navigationItem.title = "all_items_navigation_title".localize()
    view.backgroundColor = Colors.background.value
  }
}
