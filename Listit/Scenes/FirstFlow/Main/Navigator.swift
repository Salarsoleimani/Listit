//
//  Navigator.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import UIKit
import SwiftEntryKit
import Haptico

class Navigator: NSObject {
  internal let navigationController: UINavigationController
  internal let servicePackage: ServicePackage
  
  init(navigationController: UINavigationController, servicePackage: ServicePackage) {
    self.navigationController = navigationController
    self.servicePackage = servicePackage
  }
  func simpleAlert(title: String, message: String, actions: [UIAlertAction]) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    for action in actions {
      alertController.addAction(action)
    }
    return alertController
  }
  
  func toast(text: String, hapticFeedbackType: HapticoNotification, backgroundColor: UIColor) {
    var attributes = EKAttributes.toast

    attributes.entryBackground = .color(color: .init(light: backgroundColor, dark: backgroundColor))

    // Animate in and out using default translation
    attributes.entranceAnimation = .translation
    attributes.exitAnimation = .translation
    attributes.displayDuration = 3
    
    // Display the view with the configuration
    let style = EKProperty.LabelStyle(
      font: Fonts.h5Regular,
        color: .white,
        alignment: .center
    )
    let labelContent = EKProperty.LabelContent(
        text: text,
        style: style
    )
    let contentView = EKNoteMessageView(with: labelContent)
    
    Haptico.shared().generate(hapticFeedbackType)


    SwiftEntryKit.display(entry: contentView, using: attributes)
  }
  func toSetting() {
    Haptico.shared().generate(.light)
    SettingNavigator(navigationController: navigationController, servicePackage: servicePackage).setup()
  }
}


