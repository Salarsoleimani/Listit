//
//  Navigator.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import SwiftEntryKit

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
  
  func toast(text: String, hapticFeedbackType: EKAttributes.NotificationHapticFeedback, backgroundColor: UIColor) {
    var attributes = EKAttributes.toast

    attributes.entryBackground = .color(color: .init(light: backgroundColor, dark: backgroundColor))

    // Animate in and out using default translation
    attributes.entranceAnimation = .translation
    attributes.exitAnimation = .translation
    attributes.displayDuration = 3
    
    attributes.hapticFeedbackType = hapticFeedbackType
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

    SwiftEntryKit.display(entry: contentView, using: attributes)
  }
}


