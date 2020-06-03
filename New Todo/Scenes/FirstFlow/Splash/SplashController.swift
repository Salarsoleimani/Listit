//  
//  SplashController.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import UIKit
import Stellar

class SplashController: UIViewController {
  // MARK:- Outlets
  @IBOutlet weak var launchImage: UIImageView!
  @IBOutlet weak var logoLabel: UILabel!
  
  // MARK:- variables
  var viewModel: SplashViewModel!

  // MARK:- Constants

  // MARK:- LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    assert(viewModel != nil)
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animation { [unowned self] in
      self.viewModel.goToHomePage(handler: nil)
    }
  }
  // MARK:- Actions
  
  // MARK:- Functions
  private func animation(completion: @escaping () -> ()){
    let startingScale = 1 - viewModel.scalePop
    let endingScale = 1 / startingScale
    
    launchImage.delay(1).scaleXY(startingScale, startingScale).duration(0.3).easing(.easeInEaseOut).completion { [launchImage] in
      AppSoundEffects().playPopSound()
      Vibrator.vibrate(hardness: 5)
      launchImage?.image = UIImage(named: "Splash_Last")
    }.then().scaleXY(endingScale, endingScale).then().moveY(-60).snap(1).duration(1).completion {
      completion()
    }.animate()
    logoLabel.delay(1.8).moveY(32).makeAlpha(1).duration(1).animate()
  }
}
