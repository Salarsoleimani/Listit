////
////  SettingTableViewDelegates.swift
////  Listit
////
////  Created by Salar Soleimani on 2020-06-24.
////  Copyright © 2020 ssmobileapps.com All rights reserved.
////
//
//import UIKit
//import Haptico
//
//extension SettingController: UITableViewDelegate, UITableViewDataSource {
//  func numberOfSections(in tableView: UITableView) -> Int {
//    return settingData.count
//  }
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return settingData[section].count
//  }
//  
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.cellId, for: indexPath) as! SettingCell
//    cell.configure(settingData[indexPath.section][indexPath.row])
//    if Defaults.isAdsRemoved {
//      if indexPath.section == 0, indexPath.row == 1 {
//        cell.containerView.backgroundColor = Colors.main.value
//        cell.titleLabel.font = Fonts.settingBoldTitle
//      }
//    } else {
//      if indexPath.section == 1, indexPath.row == 1 {
//        cell.containerView.backgroundColor = Colors.main.value
//        cell.titleLabel.font = Fonts.settingBoldTitle
//      }
//    }
//    
//    return cell
//  }
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    if Defaults.isAdsRemoved {
//      if indexPath.section == 0, indexPath.row == 0 { // Make us better
//        composeEmail(email: Defaults.email, subject: Defaults.emailSubject)
//      } else if indexPath.section == 0, indexPath.row == 1 { // Support us
//        present(supportUsAlert, animated: true, completion: nil)
//      } else if indexPath.section == 1, indexPath.row == 0 { // Terms of use
//        Utility.openURL(url: Defaults.termsUrl)
//      } else if indexPath.section == 1, indexPath.row == 1 { // Privacy policy
//        Utility.openURL(url: Defaults.policyUrl)
//      }
//    } else {
//      if indexPath.section == 0, indexPath.row == 0 { // Remove Ads
//        IAPService.shared.purchase(product: .removeAds, delegate: self)
//      } else if indexPath.section == 0, indexPath.row == 1 { // Restore purhcase
//        IAPService.shared.restorePurchases(delegate: self)
//      } else if indexPath.section == 1, indexPath.row == 0 { // Make us better
//        composeEmail(email: Defaults.email, subject: Defaults.emailSubject)
//      } else if indexPath.section == 1, indexPath.row == 1 { // Support us
//        present(supportUsAlert, animated: true, completion: nil)
//      } else if indexPath.section == 2, indexPath.row == 0 { // Terms of use
//        Utility.openURL(url: Defaults.termsUrl)
//      } else if indexPath.section == 2, indexPath.row == 1 { // Privacy policy
//        Utility.openURL(url: Defaults.policyUrl)
//      }
//    }
//    Haptico.shared().generate(.light)
//  }
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 66
//  }
//  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return 30
//  }
//  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let headerView = UIView()
//    headerView.backgroundColor = Colors.background.value
//    return headerView
//  }
//}
