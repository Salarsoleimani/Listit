////  
////  AddTemplatesController.swift
////  Listit
////
////  Created by Salar Soleimani on 2020-08-09.
////  Copyright © 2020 SaSApps. All rights reserved.
////
//
//import UIKit
//
//class AddTemplatesController: UIViewController {
//  // MARK:- Outlets
//  @IBOutlet weak var closeButton: UIButton!
//
//  @IBOutlet weak var descriptionLabel: UILabel!
//  
//  @IBOutlet weak var motivationButton: UIButton!
//  @IBOutlet weak var birthdaysButton: UIButton!
//  @IBOutlet weak var geroceriesButton: UIButton!
//  
//  @IBOutlet weak var letsGoButton: UIButton!
//  // MARK:- variables
//  // MARK:- Constants
//  internal let  navigator: AddTemplatesNavigator
//  internal let dbManager: DatabaseManagerProtocol
//  //MARK:- Initialization
//  init(navigator: AddTemplatesNavigator, dbManager: DatabaseManagerProtocol) {
//    self.navigator = navigator
//    self.dbManager = dbManager
//    super.init(nibName: "AddTemplatesController", bundle: nil)
//  }
//  
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  // MARK:- LifeCycles
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    setupUI()
//  }
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    setLocalization()
//  }
//  // MARK:- Actions
//  
//  @IBAction func templateListsButtonPressed(_ sender: UIButton) {
//    sender.tag = sender.tag == 1 ? 0 : 1
//    let uncheckedImage = UIImage(systemName: "circle")
//    let checkedImage = UIImage(systemName: "checkmark.circle.fill")
//    let image = sender.tag == 1 ? checkedImage : uncheckedImage
//    sender.setImage(image, for: .normal)
//  }
//  @IBAction func letsGoButtonPressed(_ sender: Any) {
//    var lists = [TemplateList]()
//    if motivationButton.tag == 1 {
//      lists.append(.motivations)
//    }
//    if birthdaysButton.tag == 1 {
//      lists.append(.birthdays)
//    }
//    if geroceriesButton.tag == 1 {
//      lists.append(.geroceries)
//    }
//    dbManager.configureDataBase(templates: lists)
//    dismiss(animated: true, completion: nil)
//  }
//  @IBAction func closeButtonPressed(_ sender: Any) {
//    dbManager.configureDataBase(templates: [TemplateList]())
//    dismiss(animated: true, completion: nil)
//  }
//  // MARK:- Functions
//}
