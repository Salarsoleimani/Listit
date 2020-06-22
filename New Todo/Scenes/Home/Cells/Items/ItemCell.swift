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

class ItemCell: UICollectionViewCell {
  // MARK:- Outlets
  
  @IBOutlet weak var rowLabel: UILabel!
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var countdownLabel: CountdownLabel!
  @IBOutlet weak var isFavoriteButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var repeatContainerView: UIView!
  @IBOutlet weak var repeatLabel: UILabel!
  @IBOutlet weak var repeatIcon: UIImageView!
  
  @IBOutlet weak var reminderDateContainerView: UIView!
  @IBOutlet weak var reminderDateLabel: UILabel!
  @IBOutlet weak var reminderDateIcon: UIImageView!
  
  @IBOutlet weak var finishedLineImageView: UIImageView!
  // MARK:- Variables
  var viewModel: ItemViewModel!
  // MARK:- LifeCycles
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  // MARK:- Functions
  private func setupUI() {
    backgroundColor = .clear
    
    isFavoriteButton.tintColor = Colors.second.value
    
    rowLabel.font = Fonts.h5Regular
    rowLabel.textColor = Colors.itemCellTitle.value
    
    countdownLabel.animationType = .Scale
    
    repeatIcon.tintColor = Colors.itemCellTitle.value
    
    titleLabel.font = Fonts.itemCellTitle
    titleLabel.textColor = Colors.itemCellTitle.value
    
    descriptionLabel.font = Fonts.itemCellDescription
    descriptionLabel.textColor = Colors.itemCellDescription.value
    
    countdownLabel.font = Fonts.h2Regular
    countdownLabel.textColor = Colors.itemCellTitle.value

    repeatLabel.font = Fonts.itemCellDescription
    repeatLabel.textColor = Colors.itemCellDescription.value
    
    reminderDateIcon.tintColor = Colors.itemCellTitle.value
    
    reminderDateLabel.font = Fonts.itemCellDescription
    reminderDateLabel.textColor = Colors.itemCellDescription.value

    reminderDateContainerView.backgroundColor = .clear
    
    repeatContainerView.backgroundColor = .clear
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
    
    reminderDateContainerView.layer.borderColor = viewModel.borderColor.cgColor
    reminderDateContainerView.layer.borderWidth = 1.5
    reminderDateContainerView.layer.cornerRadius = Constants.Radius.cornerRadius
    
    repeatContainerView.layer.borderColor = viewModel.borderColor.cgColor
    repeatContainerView.layer.borderWidth = 1.5
    repeatContainerView.layer.cornerRadius = Constants.Radius.cornerRadius

    titleLabel.text = viewModel.title
    descriptionLabel.text = viewModel.description
    isFavoriteButton.setImage(viewModel.isFavoriteImage, for: .normal)
    repeatLabel.text = viewModel.repeats

    finishedLineImageView.image = viewModel.finishedLineImage
    finishedLineImageView.isHidden = viewModel.finishedLineIsHidden
    
    switch viewModel.type {
    case .reminder:
      countdownLabel.isHidden = true
      repeatContainerView.isHidden = false
      reminderDateContainerView.isHidden = false
    case .note:
      countdownLabel.isHidden = true
      repeatContainerView.isHidden = true
      reminderDateContainerView.isHidden = true
    case .countdown:
      countdownLabel.isHidden = false
      repeatContainerView.isHidden = false
      reminderDateContainerView.isHidden = false
      countdownLabel.timeFormat = viewModel.countdownTimeFormat
      countdownLabel.setCountDownDate(fromDate: NSDate(), targetDate: (viewModel.toDate ?? Date()) as NSDate)
      countdownLabel.start()
    default: break
    }
    
    descriptionLabel.isHidden = viewModel.isShowingDetail
    //reminderDateContainerView.isHidden = viewModel.isShowingDetail
    //repeatContainerView.isHidden = viewModel.isShowingDetail
  }
}
