////  
////  SettingUI.swift
////  Listit
////
////  Created by Salar Soleimani on 2020-06-23.
////  Copyright © 2020 ssmobileapps.com All rights reserved.
////
//
//import UIKit
//import Siren
//import SwiftRater
//import Haptico
//
//extension SettingController {
//  func setupUI() {
//    if Defaults.isAdsRemoved {
//      setSettingDataWithoutAd()
//    } else {
//      setSettingData()
//    }
//    
//    setLocalizations()
//    navigationItem.title = "setting_navigation_title".localize()
//
//    view.backgroundColor = Colors.background.value
//    
//    languageContainerView.backgroundColor = Colors.listCellBackground.value
//    languageContainerView.layer.cornerRadius = Constants.Radius.cornerRadius
//    
//    languageTitleLabel.textColor = Colors.listCellTitle.value
//    languageTitleLabel.font = Fonts.settingTitle
//    
//    languageButton.titleLabel?.font = Fonts.settingDescription
//    languageButton.tintColor = Colors.main.value
//    
//    versionLabel.text = "version \(Utility.version() ?? "") © 2020 listitapp.co"
//    versionLabel.textColor = Colors.listCellDescription.value
//    versionLabel.font = Fonts.h7Regular
//
//    if !Defaults.isAdsRemoved {
//      setupAds()
//    }
//  }
//  private func setSettingData() {
//    settingData = [["remove_ads_title", "restore_purchase_title"], ["make_us_better_title", "support_us_title"], ["terms_of_use_title", "policy_privacy_title"]]
//  }
//  func setSettingDataWithoutAd() {
//    settingData = [["make_us_better_title", "support_us_title"], ["terms_of_use_title", "policy_privacy_title"]]
//  }
//  
//  private func setLocalizations() {
//    navigationItem.title = "setting_navigation_title".localize()
//
//    languageTitleLabel.text = "language_title".localize()
//
//    languageButton.setTitle(LanguageManager.shared.currentLanguage.asStringName(), for: .normal)
//
//    languageAlert.title = "language_button_title".localize()
//    languageAlert.message = "language_button_description".localize()
//    
//    donateAlert.title = "donate_button_title".localize()
//    donateAlert.message = "donate_description".localize()
//  }
//  
//  func setupAlerts() {
//    setupDonateAlert()
//    setupLanguageAlert()
//    setupSupportUsAlert()
//  }
//  
//  private func setupSupportUsAlert() {
//    let donateButton = UIAlertAction(title: "donate_button_title".localize(), style: .default) { [donateButtonPressed] _ in
//      donateButtonPressed()
//    }
//    let rateUsButton = UIAlertAction(title: "rate_alert_title".localize(), style: .default) { [rateUsButtonPressed] _ in
//      rateUsButtonPressed()
//    }
//    let shareUsButton = UIAlertAction(title: "share_us_alert_title".localize(), style: .default) { [shareButtonPressed] _ in
//      shareButtonPressed()
//    }
//    let closeAction = UIAlertAction(title: "close_button_title".localize(), style: .cancel) { [supportUsAlert] button in
//      supportUsAlert.dismiss(animated: true, completion: nil)
//    }
//
//    [shareUsButton, donateButton, rateUsButton].forEach { (action) in
//      supportUsAlert.addAction(action)
//      action.setValue(Colors.main.value, forKey: "titleTextColor")
//    }
//    supportUsAlert.addAction(closeAction)
//    closeAction.setValue(Colors.listCellDescription.value, forKey: "titleTextColor")
//  }
//  
//  private func donateButtonPressed() {
//    Haptico.shared().generate(.light)
//    present(donateAlert, animated: true, completion: nil)
//  }
//  private func rateUsButtonPressed() {
//    Haptico.shared().generate(.light)
//    SwiftRater.rateApp()
//  }
//  private func shareButtonPressed() {
//    Haptico.shared().generate(.light)
//    Utility.shareText(text: Defaults.shareText, view: self)
//  }
//  
//  private func setupLanguageAlert() {
//    let ENaction = UIAlertAction(title: Languages.en.asStringName(), style: .default) { [didSelectLanguage] _ in
//      didSelectLanguage(Languages.en)
//    }
//    let FAaction = UIAlertAction(title: Languages.fa.asStringName(), style: .default) { [didSelectLanguage] _ in
//      didSelectLanguage(Languages.fa)
//    }
//    let CHaction = UIAlertAction(title: Languages.zhHans.asStringName(), style: .default) { [didSelectLanguage] _ in
//      didSelectLanguage(Languages.zhHans)
//    }
//    let closeAction = UIAlertAction(title: "close_button_title".localize(), style: .cancel) { [languageAlert] _ in
//      languageAlert.dismiss(animated: true, completion: nil)
//    }
//    [ENaction, FAaction, CHaction].forEach { (action) in
//      action.setValue(Colors.main.value, forKey: "titleTextColor")
//      languageAlert.addAction(action)
//    }
//    closeAction.setValue(Colors.listCellDescription.value, forKey: "titleTextColor")
//    languageAlert.addAction(closeAction)
//  }
//  
//  private func setupDonateAlert() {
//    let oneDolarAction = UIAlertAction(title: "0.99 USD", style: .default) { [weak self] _ in
//      self?.didSelectDonate(false, dollar: 1)
//    }
//    let threeDollarAction = UIAlertAction(title: "2.99 USD", style: .default) { [weak self] _ in
//      self?.didSelectDonate(false, dollar: 3)
//    }
//    let fiveDollarAction = UIAlertAction(title: "4.99 USD", style: .default) { [weak self] _ in
//      self?.didSelectDonate(false, dollar: 5)
//    }
//    let tenDollarAction = UIAlertAction(title: "9.99 USD", style: .default) { [weak self] _ in
//      self?.didSelectDonate(false, dollar: 10)
//    }
//    let videoAction = UIAlertAction(title: "Watch Ad video", style: .default) { [weak self] _ in
//      self?.didSelectDonate(true, dollar: 0)
//    }
//    let closeAction = UIAlertAction(title: "close_button_title".localize(), style: .cancel) { [weak self] _ in
//      self?.donateAlert.dismiss(animated: true, completion: nil)
//    }
//    [oneDolarAction, threeDollarAction, fiveDollarAction, tenDollarAction, videoAction].forEach { (action) in
//      action.setValue(Colors.main.value, forKey: "titleTextColor")
//      donateAlert.addAction(action)
//    }
//    closeAction.setValue(Colors.listCellDescription.value, forKey: "titleTextColor")
//    donateAlert.addAction(closeAction)
//  }
//  
//  private func didSelectLanguage(_ langId: Languages) {
//    // [TODO] - Force change imediately
//    switch langId {
//    case .en:
//      setLanguage(.en)
//      Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .english)
//    case .fa:
//      setLanguage(.fa)
//      Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .persianIran)
//    case .zhHans:
//      setLanguage(.zhHans)
//      Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .chineseSimplified)
//    default:
//      setLanguage(.en)
//      Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .english)
//    }
//    languageButton.setTitle(langId.asStringName(), for: .normal)
//    settingTableView.reloadData()
//  }
//  
//  private func setLanguage(_ lang: Languages) {
//    Haptico.shared().generate(.success)
//    LanguageManager.shared.setLanguage(language: lang)
//    Application.shared.setRateManagerLocalization()
//    setLocalizations()
//  }
//  
//  private func didSelectDonate(_ isVideo: Bool, dollar: Int) {
//    if isVideo {
//      if rewardedAd?.isReady == true {
//        rewardedAd?.present(fromRootViewController: self, delegate: self)
//      }
//      Haptico.shared().generate(.light)
//      return
//    }
//    switch dollar {
//    case 1:
//      IAPService.shared.purchase(product: .oneDollar)
//    case 3:
//      IAPService.shared.purchase(product: .threeDollar)
//    case 5:
//      IAPService.shared.purchase(product: .fiveDollar)
//    case 10:
//      IAPService.shared.purchase(product: .tenDollar)
//    default:
//      print("dolaro eshtebah zad")
//    }
//  }
//}
//extension Languages {
//  func asStringName() -> String {
//    switch self {
//    case .en:
//      return "English"
//    case .fa:
//      return "فارسی"
//    case .zhHans:
//      return "中文"
//    default:
//      return ""
//    }
//  }
//}
