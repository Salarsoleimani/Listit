//
//  Fonts.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import Foundation

struct Fonts {
  static let h2Bold = SSFont(.installed(.montserrat, .bold), size: .standard(.h1)).instance
  static let h2Regular = SSFont(.installed(.montserrat, .regular), size: .standard(.h1)).instance

  static let h3Regular = SSFont(.installed(.montserrat, .regular), size: .standard(.h3)).instance

  static let h5Regular = SSFont(.installed(.montserrat, .regular), size: .standard(.h5)).instance
  static let h6Regular = SSFont(.installed(.montserrat, .regular), size: .standard(.h6)).instance
  static let h7Regular = SSFont(.installed(.montserrat, .regular), size: .standard(.h7)).instance
  static let h8Regular = SSFont(.installed(.montserrat, .regular), size: .standard(.h8)).instance

  static let h5Bold = SSFont(.installed(.montserrat, .bold), size: .standard(.h5)).instance
  static let h6Bold = SSFont(.installed(.montserrat, .bold), size: .standard(.h6)).instance

  // Navigation
  static let navigationLargeTitle = SSFont(.installed(.montserrat, .bold), size: .standard(.h1)).UIFontInstance
  static let navigationTitle = SSFont(.installed(.montserrat, .bold), size: .standard(.h4)).UIFontInstance

  // Lists
  static let listCellTitle = SSFont(.installed(.montserrat, .bold), size: .standard(.h3)).instance
  static let listCellDescription = SSFont(.installed(.montserrat, .regular), size: .standard(.h5)).instance
  
  // Items
  static let itemCellTitle = SSFont(.installed(.montserrat, .regular), size: .standard(.h3)).instance
  static let itemCellDescription = SSFont(.installed(.montserrat, .regular), size: .standard(.h5)).instance
  // Setting
  static let settingTitle = SSFont(.installed(.montserrat, .regular), size: .standard(.h4)).instance
  static let settingBoldTitle = SSFont(.installed(.montserrat, .bold), size: .standard(.h4)).instance

  static let settingDescription = SSFont(.installed(.montserrat, .regular), size: .standard(.h3)).instance

  // Button
  static let button = SSFont(.installed(.montserrat, .bold), size: .standard(.h5)).instance
}
