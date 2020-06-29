//
//  AddItemAdMob.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-23.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import GoogleMobileAds
import UIKit

extension AddItemController {
  func setupAds() {
    adBannerContainerView.isHidden = false
    removeAdButton.isHidden = false
    loadBannerAd()
    addBannerAdToView()
    setupRewardedAd()
  }
  
  private func loadBannerAd() {
    bannerView.adUnitID = Constants.AdMobIds.adAddListBottomBanner // [TODO] -force change to adAddListBottomBanner
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
    rewardedAd = GADRewardedAd(adUnitID: Constants.AdMobIds.adRewardedAddList) // [TODO] -force change to adRewardedAddList
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
extension AddItemController: GADRewardedAdDelegate {
  func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
    AppAnalytics.shared.countUpRewardAd()
    isRewardedAdWatched = true
  }
  func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
    self.rewardedAd = createAndLoadRewardedAd()
  }
}
