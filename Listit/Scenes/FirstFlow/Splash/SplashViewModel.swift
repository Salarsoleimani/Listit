//  
//  SplashViewModel.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation
import UIKit

final class SplashViewModel {
  
  private let navigator: SplashNavigator
  let scalePop: CGFloat = 0.25
  init( navigator: SplashNavigator) {
    self.navigator = navigator
  }
  func goToHomePage(handler: (()->())?) {
    navigator.toHome()
  }
  func getConfiguration() {
    let urlString = "https://github.com/Salarsoleimani/Listit-Website/blob/master/Configuration.json"
    guard let url = URL(string: urlString) else { return }
    NetworkManager.shared.fetchGenericDataWithURL(url: url) { (response: ConfigurationNetworkModel?, error) in
      if let response = response, error == .ok {
        Defaults.email = response.email
        Defaults.shareText = response.shareText
        Defaults.emailSubject = response.emailSubject
      }
    }
  }
}
