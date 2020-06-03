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
    static let adBannerHomeBottom = "ca-app-pub-1135958579537389/1781667294"
    static let adRewardedHome = "ca-app-pub-1135958579537389/6650850596"
  }
  struct Keys {
    static let fontScale = "com.storageKey.fontScale"
    static let fontFamily = "com.storageKey.fontFamily"
    static let isAdsRemoved = "com.storageKey.isAdsRemoved"
    static let isOnboardingWatched = "com.storageKey.isOnboardingWatched"
    
    static let appOpenedCount = "com.storageKey.appOpenedCount"
  }
  struct Links {
    static let youtube = "https://www.youtube.com/channel/UCVv19836gsoYpdpU_FTE21Q"
    static let instagram = "https://www.instagram.com/viruscareapp"
    static let mail = "coronacareapp@gmail.com"
    static let mailSubject = "About virus care application"
  }
  
  struct Radius {
    static let cornerRadius: CGFloat = 10
  }
}