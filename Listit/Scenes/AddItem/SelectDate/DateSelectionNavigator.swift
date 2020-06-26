//  
//  DateSelectionNavigator.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-15.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation
import SwiftLocalNotification

final class DateSelectionNavigator: Navigator {
  func setup(date: Date?, repeating: RepeatingInterval, delegate: AddItemController) {
    let vc = DateSelectionController(navigator: self)
    vc.date = date
    vc.repeatingInterval = repeating
    vc.delegate = delegate
    if let lastVc = navigationController.viewControllers.last {
         lastVc.present(vc, animated: true, completion: nil)
    }
  }
}
