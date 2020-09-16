//  
//  SplashUI.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import UIKit

extension SplashController {
  func setupUI() {
    logoLabel.textColor = Colors.listCellTitle.value
    logoLabel.font = Fonts.navigationTitle
    logoLabel.text = "Listit"
  }
}
