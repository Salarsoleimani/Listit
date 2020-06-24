//
//  ItemState.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-06.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

enum ItemState: Int16 {
  case doing
  case done
  
  static var `default` = ItemState.doing
}
