//  
//  IconsViewModel.swift
//  ListHub
//
//  Created by Salar Soleimani on 2020-05-04.
//  Copyright © 2020 BEKSAS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class IconsViewModel: ViewModelType {
// MARK:- Constants
  private let navigator: IconsNavigator
// MARK:- Initialization
  init(navigator: IconsNavigator) {
    self.navigator = navigator
  }
// MARK:- Functions
  func transform(input: IconsViewModel.Input) -> IconsViewModel.Output {
    var colors = getColors().shuffled()
    colors[3].isSelected = true
    
    let icons = getIcons().map{IconCellViewModel(model: $0, colorModel: colors[3])}.shuffled()
    
    let outputIcons = Driver.combineLatest(Driver.just(icons), input.selectedColor).map { (oldIconsVM, selectedColor) -> [IconCellViewModel] in
      var newIconsVm = [IconCellViewModel]()
      for oldIcon in oldIconsVM {
        newIconsVm.append(IconCellViewModel(model: oldIcon.model, colorModel: selectedColor))
      }
      return newIconsVm
    }.startWith(icons)
    
    let outputColors = Driver.combineLatest(Driver.just(colors), input.selectedColor).map { (colors, selectedColor) -> [ColorModel] in
      var tempColors = colors
      for (index, color) in colors.enumerated() {
        if color.id == selectedColor.id {
          tempColors[index].isSelected = true
        } else {
          tempColors[index].isSelected = false
        }
      }
      return tempColors
    }.startWith(colors)
    
    let iconSelected = input.selectedIcon.map { [navigator] selectedIcon -> Void in
      navigator.popView(WithIcon: selectedIcon)
    }
    return Output(icons: outputIcons, colors: outputColors, selectedIconTrigger: iconSelected)
  }
  private func getIcons() -> [IconModel] {
    SSMocker<IconModel>.loadGenericObjectsFromLocalJson(fileName: "Icons")
  }
  private func getColors() -> [ColorModel] {
    SSMocker<ColorModel>.loadGenericObjectsFromLocalJson(fileName: "Colors")
  }
}
// MARK:- Inputs & Outputs
extension IconsViewModel {
  struct Input {
    let selectedColor: Driver<ColorModel>
    let selectedIcon: Driver<IconCellViewModel>
  }
  struct Output {
    let icons: Driver<[IconCellViewModel]>
    let colors: Driver<[ColorModel]>
    let selectedIconTrigger: Driver<Void>
  }
}
