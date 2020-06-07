//
//  MainNavigationController.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupNavigationBarUI()
  }
  private func setupUI() {
    let image = UIImage()
    navigationBar.setBackgroundImage(image, for: .default)
    navigationBar.shadowImage = image
  }
  private func setupNavigationBarUI() {
      UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
      let attrs: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.white,
        .font: Fonts.navigationLargeTitle
      ]
      UINavigationBar.appearance().prefersLargeTitles = true
      UINavigationBar.appearance().largeTitleTextAttributes = attrs
      
      //UINavigationBar.appearance().barTintColor = LHColors.navigationButtonTint.value // [TODO]
      // buttons
      UINavigationBar.appearance().titleTextAttributes = attrs
      UINavigationBar.appearance().isTranslucent = true
    }
}
