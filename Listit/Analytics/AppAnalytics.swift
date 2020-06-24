//
//  AppAnalytics.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-23.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Firebase
import Foundation
import UIKit
import FirebaseCrashlytics
import FCUUID

final public class AppAnalytics {
  public static let shared = AppAnalytics()
  
  public func setup() {
    FirebaseApp.configure()
    
    Crashlytics.crashlytics().setUserID("\(FCUUID.uuidForDevice() ?? "")")
  }
  
  public func countUpAppOpened() {
    Defaults.appOpenedCount += 1
  }
  
  public func countUpRewardAd() {
    Defaults.watchedRewardedAdCount += 1
  }
  
  public func adsRemoved() {
    Defaults.isAdsRemoved = true
  }
  public func setOboardingWatched() {
    Defaults.isOnboardingWatched = true
  }
  // Analytics
  public func log(eventName: String, parameters: [String: Any]?) {
    Analytics.logEvent(eventName, parameters: parameters)
  }
  
  // Crashlytics
  public func logCrash(_ withMessage: String) {
    Crashlytics.crashlytics().log(withMessage)
  }
  public func logCrash(_ arg: [CVarArg], format: String) {
    Crashlytics.crashlytics().log(format: format, arguments: getVaList(arg))
  }
  public func logCrash(_ customValue: Any, forKey: String) {
    Crashlytics.crashlytics().setCustomValue(customValue, forKey: forKey)
  }
  public func logCrash(_ withError: Error) {
    Crashlytics.crashlytics().record(error: withError)
  }
}
