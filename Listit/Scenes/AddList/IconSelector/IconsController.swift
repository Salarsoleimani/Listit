////  
////  IconsController.swift
////  ListHub
////
////  Created by Salar Soleimani on 2020-05-04.
////  Copyright © 2020 BEKSAS. All rights reserved.
////
//
//import UIKit
//
//class IconsController: UIViewController {
//  // MARK:- Outlets
//  @IBOutlet weak var colorsCollectionView: UICollectionView!
//  @IBOutlet weak var iconsCollectionView: UICollectionView!
//  
//  @IBOutlet weak var closeButton: UIButton!
//  @IBOutlet weak var navigationTitleLabel: UILabel!
//  @IBOutlet weak var descriptionLabel: UILabel!
//
//  // MARK:- variables
//  var viewModel: IconsViewModel!
//  var defaultIcon: BehaviorRelay<IconCellViewModel>!
//  var listTitle = ""
//  // MARK:- Constants
//  let disposeBag = DisposeBag()
//  
//  // MARK:- LifeCycles
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    setupUI()
//    registerCells()
//    bindData()
//  }
//  // MARK:- Actions
//  @IBAction private func closeButtonPressed(_ sender: UIButton) {
//    dismiss(animated: true, completion: nil)
//  }
//  // MARK:- Functions
//  private func bindData() {
//    let selectedIcon = iconsCollectionView.rx.modelSelected(IconCellViewModel.self).asDriver()
//    let selectedColor = colorsCollectionView.rx.modelSelected(ColorModel.self).asDriver()
//    let inputs = IconsViewModel.Input(selectedColor: selectedColor, selectedIcon: selectedIcon)
//    let outputs = viewModel.transform(input: inputs)
//
//    outputs.icons.drive(iconsCollectionView.rx.items(cellIdentifier: "cellId", cellType: IconCell.self)) { item, viewModel, cell in
//      cell.viewModel = viewModel
//      cell.bindData(withViewModel: viewModel)
//    }.disposed(by: disposeBag)
//    
//    outputs.colors.drive(colorsCollectionView.rx.items(cellIdentifier: "cellId", cellType: ColorCell.self)) { item, viewModel, cell in
//      cell.viewModel = viewModel
//      cell.bindData(withViewModel: viewModel)
//    }.disposed(by: disposeBag)
//    
//    outputs.selectedIconTrigger.drive().disposed(by: disposeBag)
//  }
//  private func registerCells() {
//    let iconCellXib = UINib(nibName: "IconCell", bundle: nil)
//    iconsCollectionView.register(iconCellXib, forCellWithReuseIdentifier: "cellId")
//    let colorCellXib = UINib(nibName: "ColorCell", bundle: nil)
//    colorsCollectionView.register(colorCellXib, forCellWithReuseIdentifier: "cellId")
//  }
//}
