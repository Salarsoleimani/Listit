//
//  SplashViewModel.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import Foundation
import UIKit

@MainActor class SplashViewModel: ObservableObject, ListitViewModel {
  @Published var userId: String? = ""
  @Published var toHome = false
  @Published var logoImageAnimate = false
  @Published var logoTextAnimate = false
  
  private let navigator: SplashNavigator
  private let dbManager: DatabaseManagerProtocol
  
  let width: CGFloat = Constants.DeviceScreen.width * 0.4

  init( navigator: SplashNavigator, dbManager: DatabaseManagerProtocol) {
    self.navigator = navigator
    self.dbManager = dbManager
  }
  
  @MainActor func viewAppeared() {
    Utility.delay(0.3) { [unowned self] in
      self.logoImageAnimate = true
      self.vibrate()
    }
    Utility.delay(0.4) { [unowned self] in
      self.logoTextAnimate = true
    }
    Utility.delay(1) { [unowned self] in
      self.toHome = true
    }
  }
  
  func goToHomePage() {
    Utility.delay(1) { [checkIcloudSignIn] in
      checkIcloudSignIn()
    }
  }
  
  func resetView() {
    userId = ""
    toHome = false
    logoImageAnimate = false
    logoTextAnimate = false
  }
  
  func checkIcloudSignIn() {
    dbManager.checkIsUserLoggedInIcloud { [unowned self] userId in
      Defaults.userId = userId ?? ""
      if let userId { // user is signed in to iCloud
        Task {
          await MainActor.run {
            self.navigator.toHome()
            self.userId = userId
          }
        }
      } else {
        self.toHome = false
      }
    }
  }
  
  func getConfiguration() {
    let urlString = "https://raw.githubusercontent.com/Salarsoleimani/Listit-Website/master/Configuration.json"
    guard let url = URL(string: urlString) else { return }
    NetworkManager.shared.fetchGenericDataWithURL(url: url) { (response: ConfigurationNetworkModel?, error) in
      if let response = response, error == .ok {
        Defaults.email = response.email
        Defaults.shareText = response.shareText
        Defaults.emailSubject = response.emailSubject
        Defaults.policyUrl = response.policyPrivacyUrl
        Defaults.termsUrl = response.termOfUseUrl
      }
    }
  }
}
