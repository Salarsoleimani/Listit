//
//  AddListCell.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import BEKListKit

class AddListCell: UICollectionViewCell {
  // MARK:- Outlets
  
  // MARK:- Variables
  var viewModel: String!
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
extension AddListCell: BEKBindableCell {
  typealias ViewModeltype = String
  func bindData(withViewModel viewModel: String) {
    self.viewModel = viewModel
  }
}
