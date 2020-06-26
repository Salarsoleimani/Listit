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
  }
  // MARK:- Actions
  @IBAction private func languageButtonPressed(_ sender: UIButton) {
    present(languageAlert, animated: true, completion: nil)
  }
  
  // MARK:- Functions
  private func setupTableView() {
    let nib = UINib(nibName: "SettingCell", bundle: nil)
    settingTableView.register(nib, forCellReuseIdentifier: Constants.CellIds.cellId)
    settingTableView.delegate = self
    settingTableView.dataSource = self
  }
  
  
}
extension SettingController: IAPServiceDelegate {
  func didAdsRemoved() {
    adBannerContainerView.isHidden = true
    removeAdButton.isHidden = true
  }
  
  func restoredPurchase() {
    adBannerContainerView.isHidden = true
    removeAdButton.isHidden = true
  }
}
