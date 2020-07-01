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
import Haptico

class SettingController: UIViewController {
  // MARK:- Outlets
  @IBOutlet weak var adBannerContainerView: UIView!
  @IBOutlet weak var removeAdButton: UIButton!

  @IBOutlet weak var languageContainerView: UIView!
  @IBOutlet weak var languageTitleLabel: UILabel!
  @IBOutlet weak var languageButton: UIButton!
  
  @IBOutlet weak var settingTableView: UITableView!
  @IBOutlet weak var versionLabel: UILabel!

  // MARK:- variables
  // MARK:- Constants
  let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
  var rewardedAd: GADRewardedAd?

  var settingData = [[String]]() {
    didSet {
      settingTableView.reloadData()
    }
  }
  
  let mc: MFMailComposeViewController = MFMailComposeViewController()
  
  let donateAlert = UIAlertController(title: "donate_button_title".localize(), message: "donate_description".localize(), preferredStyle: .actionSheet)
  let languageAlert = UIAlertController(title: "language_button_title".localize(), message: "language_button_description".localize(), preferredStyle: .actionSheet)
  let supportUsAlert = UIAlertController(title: "support_us_title".localize(), message: "support_us_description".localize(), preferredStyle: .actionSheet)

  private let navigator: SettingNavigator!
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
    setupAlerts()
    setupTableView()
    isAdsRemoved()
    IAPService.shared.getProducts()
  }
  // MARK:- Actions
  @IBAction private func languageButtonPressed(_ sender: UIButton) {
    Haptico.shared().generate(.light)
    present(languageAlert, animated: true, completion: nil)
  }
  @IBAction private func removeAdsButtonPressed(_ sender: UIButton) {
    IAPService.shared.purchase(product: .removeAds, delegate: self)
  }
  // MARK:- Functions
  private func isAdsRemoved() {
    if Defaults.isAdsRemoved {
      adBannerContainerView.isHidden = true
    } else {
      adBannerContainerView.isHidden = false
    }
  }
  private func setupTableView() {
    let nib = UINib(nibName: "SettingCell", bundle: nil)
    settingTableView.register(nib, forCellReuseIdentifier: Constants.CellIds.cellId)
    settingTableView.delegate = self
    settingTableView.dataSource = self
  }
}
extension SettingController: IAPServiceDelegate {
  func didAdsRemoved() {
    Haptico.shared().generate(.success)
    adBannerContainerView.isHidden = true
    removeAdButton.isHidden = true
    Defaults.isAdsRemoved = true
    navigator.toast(text: "removed_ad_success".localize(), hapticFeedbackType: .success, backgroundColor: Colors.main.value)
  }
  
  func restoredPurchase() {
    Haptico.shared().generate(.success)
    adBannerContainerView.isHidden = true
    removeAdButton.isHidden = true
    Defaults.isAdsRemoved = true
    navigator.toast(text: "restored_purchase_success".localize(), hapticFeedbackType: .success, backgroundColor: Colors.main.value)
  }
}
