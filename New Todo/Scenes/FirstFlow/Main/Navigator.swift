//
//  Navigator.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

class Navigator: NSObject {
  internal let navigationController: UINavigationController
  internal let servicePackage: ServicePackage

  init(navigationController: UINavigationController, servicePackage: ServicePackage) {
    self.navigationController = navigationController
    self.servicePackage = servicePackage
  }
}


