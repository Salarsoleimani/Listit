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
  @IBOutlet weak var iconImageView: UIImageView!
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
    
  }
  
}
// MARK:- BEKListKit
extension ListCell: BEKBindableCell {
  typealias ViewModeltype = ListItemViewModel
  func bindData(withViewModel viewModel: ListItemViewModel) {
    self.viewModel = viewModel
    iconImageView.image = viewModel.iconImage
    titleLabel.text = viewModel.title
    itemsQtyLabel.text = viewModel.itemsCount
  }
}
