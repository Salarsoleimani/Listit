//
//  ListNameCell.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import BEKListKit

class ListNameCell: UICollectionViewCell {
//MARK:- Outlets
  @IBOutlet weak var titleLabel: UILabel!
  // MARK:- Variables
  var viewModel: String!
//MARK:- LifeCycles
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
}
// MARK:- BEKListKit
extension ListNameCell: BEKBindableCell {
  typealias ViewModeltype = String
  func bindData(withViewModel viewModel: String) {
    self.viewModel = viewModel
    titleLabel.text = viewModel
  }
}
