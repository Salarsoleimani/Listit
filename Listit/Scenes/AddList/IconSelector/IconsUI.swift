////  
////  IconsUI.swift
////  ListHub
////
////  Created by Salar Soleimani on 2020-05-04.
////  Copyright © 2020 BEKSAS. All rights reserved.
////
//
//import UIKit
//
//extension IconsController {
//  func setupUI() {
//    view.backgroundColor = Colors.background.value
//    
//    closeButton.tintColor = Colors.main.value
//    
//    navigationTitleLabel.text = "select_icon_navigation_title".localize()
//    navigationTitleLabel.font = Fonts.navigationLargeTitle
//    navigationTitleLabel.textColor = Colors.listCellTitle.value
//    
//    descriptionLabel.text = String(format: "select_icon_description".localize(), listTitle)
//    descriptionLabel.font = Fonts.listCellDescription
//    descriptionLabel.textColor = Colors.listCellDescription.value
//    
//    colorsCollectionView.backgroundColor = Colors.listCellBackground.value
//    
//    setupIconsCollectionView()
//    setupColorsCollectionView()
//  }
//  private func setupColorsCollectionView() {
//    let width = 64
//    let size = CGSize(width: width , height: width)
////    colorsCollectionView.collectionViewLayout = BEKCollectionLayoutComposer.makeLayout(ForItemSize: size, minimumLineSpacing:  0, minimumInteritemSpacing: 0, estimatedItemSize: .zero, scrollDirection: .horizontal)
//  }
//  private func setupIconsCollectionView() {
//    let width = (StaticConstants.mainScreenWidth - 32 - 32) / 5 
//    let size = CGSize(width: width , height: width)
////    iconsCollectionView.collectionViewLayout = BEKCollectionLayoutComposer.makeLayout(ForItemSize: size, minimumLineSpacing:  8, minimumInteritemSpacing: 8, estimatedItemSize: .zero, scrollDirection: .vertical)
//  }
//}
