//
//  ListCell.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import BEKListKit

class ListCell: UICollectionViewCell {
  // MARK:- Outlets
  @IBOutlet weak var containerView: UIView!

  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var iconContainerView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var itemsQtyLabel: UILabel!
  // MARK:- Variables
  var viewModel: ListItemViewModel!
  // MARK:- LifeCycles
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  // MARK:- Functions
  private func setupUI() {
    containerView.backgroundColor = Colors.listCellBackground.value
    layer.cornerRadius = Constants.Radius.cornerRadius
    
    titleLabel.font = Fonts.listCellTitle
    itemsQtyLabel.font = Fonts.listCellDescription
    titleLabel.textColor = Colors.listCellTitle.value
    itemsQtyLabel.textColor = Colors.listCellDescription.value
    
  }
  
}
// MARK:- BEKListKit
extension ListCell: BEKBindableCell {
  typealias ViewModeltype = ListItemViewModel
  func bindData(withViewModel viewModel: ListItemViewModel) {
    self.viewModel = viewModel
    iconContainerView.backgroundColor = viewModel.iconColor
    iconImageView.tintColor = Colors.white.value
    iconImageView.image = viewModel.iconImage
    titleLabel.text = viewModel.title
    titleLabel.setLineSpacing(lineHeightMultiple: 0.7)
    itemsQtyLabel.text = viewModel.itemsCount
  }
}
