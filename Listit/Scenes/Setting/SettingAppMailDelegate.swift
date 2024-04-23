////
////  SettingAppMailDelegate.swift
////  Listit
////
////  Created by Salar Soleimani on 2020-06-24.
////  Copyright © 2020 ssmobileapps.com All rights reserved.
////
//
//import MessageUI
//
//extension SettingController: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
//  func composeEmail(email: String, subject: String) {
//    guard MFMailComposeViewController.canSendMail() else {
//      showFeatureNotSupportedAlert()
//      return
//    }
//    let mail = MFMailComposeViewController()
//    mail.mailComposeDelegate = self
//    mail.setToRecipients([email])
//    mail.setMessageBody("", isHTML: true)
//    mail.setSubject(subject)
//    present(mail, animated: true)
//  }
//  private func showFeatureNotSupportedAlert(message: String = "Your device does not support this feature") {
//    let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
//    let action = UIAlertAction(title: "Discard", style: .cancel, handler: nil)
//    alert.addAction(action)
//    present(alert, animated: true, completion: nil)
//  }
//  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//    controller.dismiss(animated: true)
//  }
//  
//  func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
//    controller.dismiss(animated: true)
//  }
//}
