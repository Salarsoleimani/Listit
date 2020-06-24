//
//  IconModel.swift
//  ListHub
//
//  Created by Salar Soleimani on 2020-04-28.
//  Copyright © 2020 BEKSAS. All rights reserved.
//

import UIKit

struct IconModel: Codable {
  let id: Int
  let tags: [String]
}
extension IconModel {
  func getImage() -> UIImage {
    return UIImage(named: "ic_\(id)") ?? UIImage()
  }
  static func getImageById(id: Int) -> UIImage {
    return UIImage(named: "ic_\(id)") ?? UIImage()
  }
}
