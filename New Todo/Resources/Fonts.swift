//
//  Fonts.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

struct Fonts {
  static let h2Bold = SSFont(.installed(.montserrat, .bold), size: .standard(.h1)).instance
  static let h4Regular = SSFont(.installed(.montserrat, .regular), size: .standard(.h4)).instance

  // Navigation
  static let navigationLargeTitle = SSFont(.installed(.montserrat, .bold), size: .standard(.h1)).instance
  
  // Lists
  static let listCellTitle = SSFont(.installed(.montserrat, .bold), size: .standard(.h3)).instance
  static let listCellDescription = SSFont(.installed(.montserrat, .regular), size: .standard(.h5)).instance
}
