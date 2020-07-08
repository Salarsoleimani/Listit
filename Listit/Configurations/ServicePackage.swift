//
//  ServicePackage.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import Foundation

final class ServicePackage {
  public let dbManager: DatabaseManagerProtocol
  public init(dbManager: DatabaseManagerProtocol) {
    self.dbManager = dbManager
  }
}
