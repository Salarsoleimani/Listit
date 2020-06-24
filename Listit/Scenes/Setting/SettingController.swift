//  
//  SettingController.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-23.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MessageUI
import SwiftRater
import Siren

class SettingController: UIViewController {
  // MARK:- Outlets
  @IBOutlet weak var languageContainerView: UIView!
  @IBOutlet weak var languageLabel: UILabel!
  @IBOutlet weak var languageTitleLabel: UILabel!
  @IBOutlet weak var languageButton: UIButton!
  // MARK:- variables
  // MARK:- Constants
  let mc: MFMailComposeViewController = MFMailComposeViewController()

  let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
  var rewardedAd: GADRewardedAd?
  let donateAlert = UIAlertController(title: "Donate_Button_Title".localize(), message: "Donate_Description".localize(), preferredStyle: .actionSheet)
  private let navigator: SettingNavigator!
  let languageAlert = UIAlertController(title: "Language_Button_Title".localize(), message: "Language_Button_Description".localize(), preferredStyle: .actionSheet)

  //MARK:- Initialization
  init(navigator: SettingNavigator) {
    self.navigator = navigator
    super.init(nibName: "SettingController", bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK:- LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupDonateAlert()

  }
  // MARK:- Actions
  @IBAction func removeAdsButtonPressed(_ sender: UIButton) {
    IAPService.shared.purchase(product: .removeAds, delegate: self)
  }
  @IBAction func donateButtonPressed(_ sender: UIButton) {
    present(donateAlert, animated: true, completion: nil)
  }
  @IBAction func rateUsButtonPressed(_ sender: UIButton) {
    SwiftRater.rateApp()
  }
  // MARK:- Functions
  private func setupDonateAlert() {
    let oneDolarAction = UIAlertAction(title: "0.99 USD", style: .default) { [weak self] _ in
      self?.didSelectDonate(false, dollar: 1)
    }
    let threeDollarAction = UIAlertAction(title: "2.99 USD", style: .default) { [weak self] _ in
      self?.didSelectDonate(false, dollar: 3)
    }
    let fiveDollarAction = UIAlertAction(title: "4.99 USD", style: .default) { [weak self] _ in
      self?.didSelectDonate(false, dollar: 5)
    }
    let tenDollarAction = UIAlertAction(title: "9.99 USD", style: .default) { [weak self] _ in
      self?.didSelectDonate(false, dollar: 10)
    }
    let twentyDollarAction = UIAlertAction(title: "19.99 USD", style: .default) { [weak self] _ in
      self?.didSelectDonate(false, dollar: 20)
    }
    let fiftyDollarAction = UIAlertAction(title: "49.99 USD", style: .default) { [weak self] _ in
      self?.didSelectDonate(false, dollar: 50)
    }
    let hundredDollarAction = UIAlertAction(title: "99.99 USD", style: .default) { [weak self] _ in
      self?.didSelectDonate(false, dollar: 100)
    }
    let videoAction = UIAlertAction(title: "Watch ad video", style: .default) { [weak self] _ in
      self?.didSelectDonate(true, dollar: 0)
    }
    let closeAction = UIAlertAction(title: "Close", style: .cancel) { [weak self] _ in
      self?.donateAlert.dismiss(animated: true, completion: nil)
    }
    [oneDolarAction, threeDollarAction, fiveDollarAction, tenDollarAction, twentyDollarAction, fiftyDollarAction, hundredDollarAction, videoAction, closeAction].forEach { (action) in
      donateAlert.addAction(action)
    }
  }
  private func didSelectDonate(_ isVideo: Bool, dollar: Int) {
    if isVideo {
      if rewardedAd?.isReady == true {
        rewardedAd?.present(fromRootViewController: self, delegate: self)
      }
      return
    }
    switch dollar {
    case 1:
      IAPService.shared.purchase(product: .oneDollar)
    case 3:
      IAPService.shared.purchase(product: .threeDollar)
    case 5:
      IAPService.shared.purchase(product: .fiveDollar)
    case 10:
      IAPService.shared.purchase(product: .tenDollar)
    default:
      print("dolaro eshtebah zad")
    }
  }
  private func setupLanguageAlert() {
    let ENaction = UIAlertAction(title: Languages.en.asStringName(), style: .default) { [weak self] _ in
      self?.didSelectLanguage(Languages.en)
    }
    let FAaction = UIAlertAction(title: Languages.fa.asStringName(), style: .default) { [weak self] _ in
      self?.didSelectLanguage(Languages.fa)
    }
    let CHaction = UIAlertAction(title: Languages.zhHans.asStringName(), style: .default) { [weak self] _ in
      self?.didSelectLanguage(Languages.zhHans)
    }
    let closeAction = UIAlertAction(title: "Close", style: .cancel) { [weak self] _ in
      self?.languageAlert.dismiss(animated: true, completion: nil)
    }
    [ENaction, FAaction, CHaction, closeAction].forEach { (action) in
      languageAlert.addAction(action)
    }
  }
  private func didSelectLanguage(_ langId: Languages) {
    // [TODO] - Force change imediately
    switch langId {
    case .en:
      setLanguage(.en)
      Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .english)
    case .fa:
      setLanguage(.fa)
      Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .persianIran)
    case .zhHans:
      setLanguage(.zhHans)
      Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .chineseSimplified)
    default:
      setLanguage(.en)
      Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .english)
    }
    languageLabel.text = langId.asStringName()
  }
  private func setLanguage(_ lang: Languages) {
    LanguageManager.shared.setLanguage(language: lang)
    setupUI()
  }
}
extension Languages {
  func asStringName() -> String {
    switch self {
    case .en:
      return "English"
    case .fa:
      return "فارسی"
    case .zhHans:
      return "中文"
    default:
      return ""
    }
  }
}
extension SettingController: GADRewardedAdDelegate {
  func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
    AppAnalytics.shared.countUpRewardAd()
  }
  func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
    //self.rewardedAd = createAndLoadRewardedAd()
  }
}
extension SettingController: IAPServiceDelegate {
  func didAdsRemoved(completion: @escaping () -> ()) {
    
  }
}
