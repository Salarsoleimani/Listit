////
////  ItemCell.swift
////  Listit
////
////  Created by Salar Soleimani on 2020-06-03.
////  Copyright © 2020 ssmobileapps.com All rights reserved.
////
//
//import UIKit
//
//class ItemCell {
//  // MARK:- Outlets
//    
//  @IBOutlet weak var containerView: UIView!
//  @IBOutlet weak var containerStackView: UIStackView!
//
//  @IBOutlet weak var favoriteView: UIView!
//
////  @IBOutlet weak var countdownLabel: CountdownLabel!
//
//  @IBOutlet weak var titleLabel: UILabel!
//  
//  @IBOutlet weak var descriptionLabel: UILabel!
//
//  @IBOutlet weak var repeatContainerView: UIView!
//  @IBOutlet weak var repeatLabel: UILabel!
//  @IBOutlet weak var repeatIcon: UIImageView!
//  
//  @IBOutlet weak var reminderDateContainerView: UIView!
//  @IBOutlet weak var reminderDateLabel: UILabel!
//  @IBOutlet weak var reminderDateIcon: UIImageView!
//  
//  @IBOutlet weak var dateContainerStackView: UIStackView!
//
//  @IBOutlet weak var finishedLineImageView: UIImageView!
//  
//  // MARK:- Variables
//  var viewModel: ItemViewModel!
//  var isShowingDetail = false
//  // MARK:- LifeCycles
//  
////  override func awakeFromNib() {
//    super.awakeFromNib()
//    setupUI()
//  }
//  // MARK:- Functions
//  private func setupUI() {
//    backgroundColor = .clear
//    
//    containerView.backgroundColor = .clear
//    
//    favoriteView.backgroundColor = Colors.red.value
//    
//    containerView.layer.borderWidth = 1.5
//    containerView.layer.cornerRadius = Constants.Radius.cornerRadius
//            
//    countdownLabel.animationType = .Scale
//    
//    repeatIcon.tintColor = Colors.itemCellTitle.value
//    
//    titleLabel.font = Fonts.itemCellTitle
//    titleLabel.textColor = Colors.itemCellTitle.value
//    
//    descriptionLabel.font = Fonts.itemCellDescription
//    descriptionLabel.textColor = Colors.itemCellDescription.value
//    
//    countdownLabel.font = Fonts.h2Regular
//    countdownLabel.textColor = Colors.itemCellTitle.value
//
//    repeatLabel.font = Fonts.itemCellDescription
//    repeatLabel.textColor = Colors.itemCellDescription.value
//    
//    reminderDateIcon.tintColor = Colors.itemCellTitle.value
//    
//    reminderDateLabel.font = Fonts.itemCellDescription
//    reminderDateLabel.textColor = Colors.itemCellDescription.value
//    reminderDateLabel.adjustsFontSizeToFitWidth = true
//    
//    reminderDateContainerView.backgroundColor = .clear
//    reminderDateContainerView.layer.borderWidth = 1.5
//    reminderDateContainerView.layer.cornerRadius = Constants.Radius.cornerRadius
//    
//    repeatContainerView.backgroundColor = .clear
//    repeatContainerView.layer.borderWidth = 1.5
//    repeatContainerView.layer.cornerRadius = Constants.Radius.cornerRadius
//  }
//  
////  @IBAction func isFavoriteButtonPressed(_ sender: Any) {
////    if viewModel.model.isFavorite {
////      viewModel.model.isFavorite = false
////      let image = UIImage(systemName: "star")!.withTintColor(Colors.second.value, renderingMode: .alwaysTemplate)
////      //isFavoriteButton.setImage(image, for: .normal)
////    } else {
////      viewModel.model.isFavorite = true
////      let image = UIImage(systemName: "star.fill")!.withTintColor(Colors.second.value, renderingMode: .alwaysTemplate)
////      //isFavoriteButton.setImage(image, for: .normal)
////    }
////    CoreDataStack.shared.saveContext()
////  }
//}
//
//// MARK:- BEKListKit
//extension ItemCell {
//  func bindData(withViewModel viewModel: ItemViewModel) {
//    self.viewModel = viewModel
//
//    containerView.layer.borderColor = viewModel.borderColor.cgColor
//    
//    favoriteView.isHidden = viewModel.isFavoriteHidden
//    
//    reminderDateContainerView.layer.borderColor = viewModel.borderColor.cgColor
//    
//    repeatContainerView.layer.borderColor = viewModel.borderColor.cgColor
//    
//    titleLabel.text = viewModel.title
//    descriptionLabel.text = viewModel.description
//
//    repeatLabel.text = viewModel.repeats
//
//    finishedLineImageView.image = viewModel.finishedLineImage
//    finishedLineImageView.isHidden = viewModel.finishedLineIsHidden
//    
//    reminderDateLabel.text = viewModel.dueDate
//    if viewModel.type == .countdown, viewModel.finishedLineIsHidden {
//      countdownLabel.timeFormat = viewModel.countdownTimeFormat
//      countdownLabel.setCountDownDate(fromDate: NSDate(), targetDate: (viewModel.toDate ?? Date()) as NSDate)
//      countdownLabel.start()
//    } else {
//      countdownLabel.cancel()
//      countdownLabel.text = "mark_as_completed_item_title".localize()
//    }
//  }
//  
//  func showDetail(_ isShowingDetail: Bool = false) {
//    if viewModel.description.isEmpty {
//      descriptionLabel.isHidden = true
//    } else {
//      descriptionLabel.isHidden = false
//    }
//    if isShowingDetail {
//      descriptionLabel.isHidden = false
//      switch viewModel.type {
//      case .reminder:
//        dateContainerStackView.isHidden = false
//
//        reminderDateLabel.isHidden = false
//        reminderDateContainerView.isHidden = false
//        reminderDateIcon.isHidden = false
//        
//        repeatContainerView.isHidden = false
//        repeatLabel.isHidden = false
//        repeatIcon.isHidden = false
//
//        countdownLabel.isHidden = true
//      case .note:
//        dateContainerStackView.isHidden = true
//
//        reminderDateLabel.isHidden = true
//        reminderDateContainerView.isHidden = true
//        reminderDateIcon.isHidden = true
//        
//        repeatContainerView.isHidden = true
//        repeatLabel.isHidden = true
//        repeatIcon.isHidden = true
//
//        countdownLabel.isHidden = true
//      case .countdown:
//        dateContainerStackView.isHidden = false
//
//        reminderDateLabel.isHidden = false
//        reminderDateContainerView.isHidden = false
//        reminderDateIcon.isHidden = false
//        
//        repeatContainerView.isHidden = false
//        repeatLabel.isHidden = false
//        repeatIcon.isHidden = false
//        if viewModel.model.notifDate == nil {
//          countdownLabel.isHidden = true
//        } else {
//          countdownLabel.isHidden = false
//        }
//        
//      default: break
//      }
//    } else {
//      descriptionLabel.isHidden = true
//      dateContainerStackView.isHidden = true
//
//      switch viewModel.type {
//      case .reminder:
//
//        reminderDateLabel.isHidden = true
//        reminderDateContainerView.isHidden = true
//        reminderDateIcon.isHidden = true
//        
//        repeatContainerView.isHidden = true
//        repeatLabel.isHidden = true
//        repeatIcon.isHidden = true
//        
//        countdownLabel.isHidden = true
//      case .note:
//
//        reminderDateLabel.isHidden = true
//        reminderDateContainerView.isHidden = true
//        reminderDateIcon.isHidden = true
//        
//        repeatContainerView.isHidden = true
//        repeatLabel.isHidden = true
//        repeatIcon.isHidden = true
//        
//        countdownLabel.isHidden = true
//      case .countdown:
//
//        reminderDateLabel.isHidden = true
//        reminderDateContainerView.isHidden = true
//        reminderDateIcon.isHidden = true
//        
//        repeatContainerView.isHidden = true
//        repeatLabel.isHidden = true
//        repeatIcon.isHidden = true
//        if viewModel.model.notifDate == nil {
//          countdownLabel.isHidden = true
//        } else {
//          countdownLabel.isHidden = false
//        }
//      default: break
//      }
//    }
//    contentView.layoutIfNeeded()
//    contentView.layoutSubviews()
//  }
//}
