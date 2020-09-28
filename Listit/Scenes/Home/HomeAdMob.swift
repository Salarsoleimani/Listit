//
//  HomeAdMob.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-23.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import GoogleMobileAds
import UIKit

extension HomeController {
  func setupAds() {
    adBannerContainerView.isHidden = false
    removeAdButton.isHidden = false
    loadBannerAd()
    addBannerAdToView()
    setupRewardedAd()
  }
  private func loadBannerAd() {
    bannerView.adUnitID = Constants.AdMobIds.adHomeBottomBanner // [TODO] -force change to adHomeBottomBanner testAdBannerUnitID
    bannerView.rootViewController = self
    bannerView.load(GADRequest())
  }
  private func addBannerAdToView() {
    adBannerContainerView.addSubview(bannerView)
    NSLayoutConstraint.activate([
      adBannerContainerView.leftAnchor.constraint(equalTo: bannerView.leftAnchor, constant: 8),
      removeAdButton.leftAnchor.constraint(equalTo: bannerView.rightAnchor),
      adBannerContainerView.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor),
      adBannerContainerView.topAnchor.constraint(equalTo: bannerView.topAnchor)
    ])
    adBannerContainerView.layoutIfNeeded()

  }
  private func setupRewardedAd() {
    if Defaults.appOpenedCount > 15 {
      rewardedAd = createAndLoadRewardedAd()
    }
  }
  private func createAndLoadRewardedAd() -> GADRewardedAd? {
    rewardedAd = GADRewardedAd(adUnitID: Constants.AdMobIds.adRewardedHome) // [TODO] -force change to adRewardedHome testAdRewardedVideoUnitID
    rewardedAd?.load(GADRequest()) { error in
      if let error = error {
        print("Loading ad failed: \(error)")
      } else {
        print("Loading ad Succeeded")
      }
    }
    return rewardedAd
  }
  func showRewardedAd() {
    if rewardedAd?.isReady == true {
      rewardedAd?.present(fromRootViewController: self, delegate: self)
    }
  }
}
extension HomeController: GADRewardedAdDelegate {
  func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
    AppAnalytics.shared.countUpRewardAd()
  }
  func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
    self.rewardedAd = createAndLoadRewardedAd()
  }
}
