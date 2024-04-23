//
//  Application.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import UIKit
import Siren
import SwiftRater
import IQKeyboardManagerSwift
import GoogleMobileAds

final class Application {
  static let shared = Application()
  
  private init() {
    AppAnalytics.shared.setup()
  }
  
  @MainActor func configureMainInterface(in window: UIWindow) {
    let mainNavigationController = MainNavigationController()
    window.rootViewController = mainNavigationController
    window.makeKeyAndVisible()
    let dbManager = DBManager()
    SplashNavigator(navigationController: mainNavigationController, servicePackage: ServicePackage(dbManager: dbManager)).setup()
  }
  
  func setupApplicationConfigurations() {
    LanguageManager.shared.defaultLanguage = .deviceLanguage
    setupRateManager()
    setupUpdateManager()
    resetNotificationBadge()
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["72ef0c1b55cbe0034f0d1a5fd0fca1df"]
  }
  
  private func configureKeyboard() {
//    IQKeyboardManager.shared.enable = true
//    IQKeyboardManager.shared.toolbarTintColor = Colors.main.value
//    IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(HomeController.self)
  }
  
  private func setupUpdateManager() {
    Siren.shared.wail()
    Siren.shared.rulesManager = RulesManager(majorUpdateRules: Rules(promptFrequency: .immediately, forAlertType: .force), minorUpdateRules: Rules(promptFrequency: .daily, forAlertType: .option), patchUpdateRules: Rules(promptFrequency: .weekly, forAlertType: .skip), revisionUpdateRules: Rules.default, showAlertAfterCurrentVersionHasBeenReleasedForDays: 3)
  }
  
  private func resetNotificationBadge() {
    UIApplication.shared.applicationIconBadgeNumber = 0
  }
  func setRateManagerLocalization() {
    SwiftRater.alertCancelTitle = "Rate_alertCancelTitle".localize()
    SwiftRater.alertMessage = "Rate_alertMessage".localize()
    SwiftRater.alertRateLaterTitle = "Rate_alertRateLaterTitle".localize()
    SwiftRater.alertRateTitle = "Rate_alertRateTitle".localize()
    SwiftRater.alertTitle = "Rate_alertTitle".localize()
  }
  private func setupRateManager() {
    setRateManagerLocalization()
    
    SwiftRater.daysUntilPrompt = 2
    SwiftRater.usesUntilPrompt = 10
    SwiftRater.significantUsesUntilPrompt = 3
    SwiftRater.daysBeforeReminding = 1
    SwiftRater.showLaterButton = true
    SwiftRater.debugMode = true
    SwiftRater.appLaunched()
  }
  
}
