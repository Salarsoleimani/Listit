//
//  Defaults.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import Foundation

/// UserDefaults for Application layer
struct Defaults {
  // Appereance
  @UserDefault(Constants.Keys.fontScale, defaultValue: 1.0)
  static var fontScale: Double
  
  @UserDefault(Constants.Keys.fontFamily, defaultValue: "Montserrat")
  static var fontFamily: String
  
  // Database
  @UserDefault(Constants.Keys.isDatabaseConfigured, defaultValue: false)
  static var isDatabaseConfigured: Bool
  
  // Analytics
  @UserDefault(Constants.Keys.appOpenedCount, defaultValue: 0)
  static var appOpenedCount: Int
  
  @UserDefault(Constants.Keys.watchedRewardAd, defaultValue: 0)
  static var watchedRewardedAdCount: Int
  
  @UserDefault(Constants.Keys.isAdsRemoved, defaultValue: false)
  static var isAdsRemoved: Bool
  
  @UserDefault(Constants.Keys.isOnboardingWatched, defaultValue: false)
  static var isOnboardingWatched: Bool
  
  // From Server
  @UserDefault(Constants.Keys.email, defaultValue: "listitappco@gmail.com")
  static var email: String
  
  @UserDefault(Constants.Keys.emailSubject, defaultValue: "Feedback")
  static var emailSubject: String
  
  @UserDefault(Constants.Keys.shareText, defaultValue: "Hi,/nI am using Listit. It is amazing and so useful. I taught it would help you too./nGo visit their website:/nwww.listitapp.co/n/nor simply download it from Appstore:\nhttps://")
  static var shareText: String
  
  @UserDefault(Constants.Keys.policyUrl, defaultValue: "https://listitapps.herokuapp.com/policy")
  static var policyUrl: String
  
  @UserDefault(Constants.Keys.termsUrl, defaultValue: "https://listitapps.herokuapp.com/terms")
  static var termsUrl: String
}
