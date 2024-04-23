//
//  CoreDataError.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import Foundation

public enum CoreDataError: Error {
  case updateError
  case addError
  case deleteError
  case isEmpty
  case getError
  case unknown
}
