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
  static let h5Regular = SSFont(.installed(.montserrat, .regular), size: .standard(.h5)).instance
  static let h7Regular = SSFont(.installed(.montserrat, .regular), size: .standard(.h7)).instance

  static let h5Bold = SSFont(.installed(.montserrat, .bold), size: .standard(.h5)).instance

  // Navigation
  static let navigationLargeTitle = SSFont(.installed(.montserrat, .bold), size: .standard(.h1)).instance
  static let navigationTitle = SSFont(.installed(.montserrat, .bold), size: .standard(.h4)).instance

  // Lists
  static let listCellTitle = SSFont(.installed(.montserrat, .bold), size: .standard(.h3)).instance
  static let listCellDescription = SSFont(.installed(.montserrat, .regular), size: .standard(.h5)).instance
  
  // Items
  static let itemCellTitle = SSFont(.installed(.montserrat, .bold), size: .standard(.h3)).instance
  static let itemCellDescription = SSFont(.installed(.montserrat, .regular), size: .standard(.h5)).instance
  
  // Button
  static let button = SSFont(.installed(.montserrat, .bold), size: .standard(.h5)).instance
}
