//
//  Defaults.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation

/// UserDefaults for Application layer
struct Defaults {
  @UserDefault(Constants.Keys.appOpenedCount, defaultValue: 0)
  static var appOpenedCount: Int
  
  @UserDefault(Constants.Keys.isAdsRemoved, defaultValue: false)
  static var isAdsRemoved: Bool
  
  @UserDefault(Constants.Keys.isOnboardingWatched, defaultValue: false)
  static var isOnboardingWatched: Bool
  
  @UserDefault(Constants.Keys.fontScale, defaultValue: 1.0)
  static var fontScale: Double
  
  @UserDefault(Constants.Keys.fontFamily, defaultValue: "Montserrat")
  static var fontFamily: String
}
