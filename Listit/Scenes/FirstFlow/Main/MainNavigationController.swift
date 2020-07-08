//
//  MainNavigationController.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import UIKit

class MainNavigationController: SloppySwipingNav {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupNavigationBarUI()
  }
  private func setupUI() {
    //    let image = UIImage()
    //    navigationBar.setBackgroundImage(image, for: .default)
    //    navigationBar.shadowImage = image
  }
  private func setupNavigationBarUI() {
    UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
    let largAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: Colors.title.value,
      .font: Fonts.navigationLargeTitle
    ]
    let defaultAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: Colors.title.value,
      .font: Fonts.navigationTitle
    ]
    
    UINavigationBar.appearance().prefersLargeTitles = true
    UINavigationBar.appearance().largeTitleTextAttributes = largAttributes
    
    UINavigationBar.appearance().tintColor = Colors.main.value
    // buttons
    UINavigationBar.appearance().titleTextAttributes = defaultAttributes
    UINavigationBar.appearance().isTranslucent = true
  }
}
