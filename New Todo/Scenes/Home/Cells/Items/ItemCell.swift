//
//  ItemCell.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-03.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import BEKListKit
import CountdownLabel

class ItemCell: UITableViewCell {
  // MARK:- Outlets
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var countdownLabel: CountdownLabel!
  @IBOutlet weak var isFavoriteButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var repeatLabel: UILabel!
  @IBOutlet weak var repeatIcon: UIImageView!
  // MARK:- Variables
  var viewModel: ItemViewModel!
  // MARK:- LifeCycles
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  // MARK:- Functions
  private func setupUI() {
    countdownLabel.animationType = .Scale
    repeatIcon.tintColor = Colors.itemCellTitle.value
    
    titleLabel.font = Fonts.itemCellTitle
    titleLabel.textColor = Colors.itemCellTitle.value
    
    descriptionLabel.font = Fonts.itemCellDescription
    descriptionLabel.textColor = Colors.itemCellDescription.value
    
    countdownLabel.font = Fonts.h5Regular
    countdownLabel.textColor = Colors.itemCellTitle.value

    repeatLabel.font = Fonts.itemCellDescription
    repeatLabel.textColor = Colors.itemCellDescription.value
  }
  
  @IBAction func isFavoriteButtonPressed(_ sender: Any) {
    if viewModel.model.isFavorite {
      viewModel.model.isFavorite = false
      let image = UIImage(systemName: "star")!.withTintColor(Colors.second.value, renderingMode: .alwaysTemplate)
      isFavoriteButton.setImage(image, for: .normal)
    } else {
      viewModel.model.isFavorite = true
      let image = UIImage(systemName: "star.fill")!.withTintColor(Colors.second.value, renderingMode: .alwaysTemplate)
      isFavoriteButton.setImage(image, for: .normal)
    }
    CoreDataStack.shared.saveContext()
  }
}

// MARK:- BEKListKit
extension ItemCell: BEKBindableCell {
  typealias ViewModeltype = ItemViewModel
  func bindData(withViewModel viewModel: ItemViewModel) {
    self.viewModel = viewModel
    containerView.backgroundColor = viewModel.backgroundColor
    containerView.layer.cornerRadius = Constants.Radius.cornerRadius
    containerView.layer.borderColor = viewModel.borderColor.cgColor
    containerView.layer.borderWidth = 1.5
    
    titleLabel.text = viewModel.title
    descriptionLabel.text = viewModel.description
    isFavoriteButton.setImage(viewModel.isFavoriteImage, for: .normal)
    repeatLabel.text = viewModel.repeats

    switch viewModel.type {
    case .reminder:
      countdownLabel.isHidden = true
      repeatLabel.isHidden = false
      repeatIcon.isHidden = false
    case .note:
      countdownLabel.isHidden = true
      repeatLabel.isHidden = true
      repeatIcon.isHidden = true
    case .countdown:
      countdownLabel.isHidden = false
      repeatLabel.isHidden = false
      repeatIcon.isHidden = false
      countdownLabel.setCountDownDate(fromDate: NSDate(), targetDate: (viewModel.toDate ?? Date()) as NSDate)
    default: break
    }
  }
}
