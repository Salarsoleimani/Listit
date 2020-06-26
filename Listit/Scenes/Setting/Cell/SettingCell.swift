//
//  SettingCell.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-24.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
  // MARK:- Outlets
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  var model: String!
  // MARK:- Initilization
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  // MARK:- Functions
  func configure(_ model: String) {
    self.model = model
    titleLabel.text = model
  }
  private func setupUI() {
    backgroundColor = Colors.background.value
    
    containerView.backgroundColor = Colors.listCellBackground.value
    containerView.layer.cornerRadius = Constants.Radius.cornerRadius
    
    titleLabel.textColor = Colors.listCellTitle.value
    titleLabel.font = Fonts.settingTitle
  }
}
