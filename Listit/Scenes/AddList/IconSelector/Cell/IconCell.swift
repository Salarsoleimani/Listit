//
//  IconCell.swift
//  ListHub
//
//  Created by Salar Soleimani on 2020-05-04.
//  Copyright © 2020 BEKSAS. All rights reserved.
//

import UIKit

class IconCell: UICollectionViewCell {
  // MARK:- Outlets
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var iconContainerView: UIView!

  // MARK:- Variables
  var viewModel: IconCellViewModel!
  // MARK:- LifeCycles

  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  // MARK:- Functions
  func bindData(withViewModel viewModel: IconCellViewModel) {
    self.viewModel = viewModel
    iconImageView.image = viewModel.image
//    iconImageView.tintColor = Colors.white.value
    iconContainerView.backgroundColor = viewModel.color
    backgroundColor = viewModel.color
  }
  private func setupUI() {
    let width = (Constants.DeviceScreen.width - 32 - 32) / 5 
    layer.cornerRadius = width / 2
  }
}
