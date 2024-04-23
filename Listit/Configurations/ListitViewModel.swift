//
//  ListitViewModel.swift
//  Listit
//
//  Created by Salar Soleimani on 2024-04-22.
//  Copyright © 2024 SaSApps. All rights reserved.
//

import Foundation
import Haptico

protocol ListitViewModel { }

extension ListitViewModel {
  func vibrate(isSuccess: Bool = true) {
    if isSuccess {
      Haptico.shared().generate(.success)
    } else {
      Haptico.shared().generate(.error)
    }
  }
}
