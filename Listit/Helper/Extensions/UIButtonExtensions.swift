//
//  UIButtonExtensions.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-10.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

extension UIButton {
  func makeNewTodoButton(title: String) {
    backgroundColor = Colors.main.value
    layer.cornerRadius = Constants.Radius.cornerRadius
    setTitle(title, for: .normal)
    titleLabel?.font = Fonts.button
    tintColor = Colors.white.value
  }
}
