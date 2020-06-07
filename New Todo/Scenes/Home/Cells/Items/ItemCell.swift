//
//  ItemCell.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import BEKListKit

class ItemCell: UITableViewCell {
  // MARK:- Outlets
  @IBOutlet weak var titleLabel: UILabel!
  // MARK:- Variables
  var viewModel: ItemViewModel!
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
extension ItemCell: BEKBindableCell {
  typealias ViewModeltype = ItemViewModel
  func bindData(withViewModel viewModel: ItemViewModel) {
    self.viewModel = viewModel
    titleLabel.text = viewModel.title
  }
}
