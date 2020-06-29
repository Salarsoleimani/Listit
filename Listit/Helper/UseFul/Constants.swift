//
//  Constants.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

enum Constants {
  struct AdMobIds {
    // testAdUnitIds
    static let testAdBannerUnitID = "ca-app-pub-3940256099942544/2934735716"
    static let testAdInterstitialUnitID = "ca-app-pub-3940256099942544/4411468910"
    static let testAdInterstitialVideoUnitID = "ca-app-pub-3940256099942544/5135589807"
    static let testAdRewardedVideoUnitID = "ca-app-pub-3940256099942544/1712485313"
    static let testAdNativeAdvancedUnitID = "ca-app-pub-3940256099942544/3986624511"
    static let testAdNativeAdvancedVideoUnitID = "ca-app-pub-3940256099942544/2521693316"
    // my ads unit ids
    
    static let adRewardedHome = "ca-app-pub-1135958579537389/7638984237"
    static let adHomeBottomBanner = "ca-app-pub-1135958579537389/6517474251"

    static let adSettingBottomBanner = "ca-app-pub-1135958579537389/1456719265"
    static let adRewardedSetting = "ca-app-pub-1135958579537389/5232027335"
    
    static let adRewardedAddItem = "ca-app-pub-1135958579537389/3657901848"
    static let adAddItemBottomBanner = "ca-app-pub-1135958579537389/3773451918"
    
    static let adRewardedAddList = "ca-app-pub-1135958579537389/5086533583"
    static let adAddListBottomBanner = "ca-app-pub-1135958579537389/3727373970"
  }
  struct Keys {
    static let fontScale = "com.storageKey.fontScale"
    static let fontFamily = "com.storageKey.fontFamily"
    static let isAdsRemoved = "com.storageKey.isAdsRemoved"

    static let isDatabaseConfigured = "com.storageKey.isDatabaseConfigured"

    static let appOpenedCount = "com.storageKey.appOpenedCount"
    static let watchedRewardAd = "com.storageKey.watchedRewardAd"
    static let removeAds = "com.storageKey.removeAds"
    static let isOnboardingWatched = "com.storageKey.isOnboardingWatched"
    static let userFullName = "com.storageKey.userFullName"
    
    // From Server
    static let email = "com.storageKey.email"
    static let emailSubject = "com.storageKey.emailSubject"
    static let shareText = "com.storageKey.shareText"


  }
  struct Links {
    static let youtube = "https://www.youtube.com/channel/UCVv19836gsoYpdpU_FTE21Q"
    static let instagram = "https://www.instagram.com/viruscareapp"
    static let mail = "coronacareapp@gmail.com"
    static let mailSubject = "About virus care application"
  }
  
  struct Radius {
    static let cornerRadius: CGFloat = 13
    static let textViewCornerRadius: CGFloat = 8
  }
  
  struct Defaults {
    static let color = "#217C6B"
  }
  struct CellIds {
    static let cellId = "cellId"
  }
}
