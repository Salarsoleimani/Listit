//  
//  DateSelectionController.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-15.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import UIKit
import RxSwift
import SwiftLocalNotification

class DateSelectionController: UIViewController {
  // MARK:- Outlets
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var navigationTitleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var repeatsTitleLabel: UILabel!
  @IBOutlet weak var repeatsContainerView: UIView!
  @IBOutlet weak var repeatsSegmentedControl: UISegmentedControl!
  
  @IBOutlet weak var dateTitleLabel: UILabel!
  @IBOutlet weak var dateContainerView: UIView!
  @IBOutlet weak var dateContainerViewStackView: UIStackView!

  @IBOutlet weak var dateTextField: UITextField!
  @IBOutlet weak var timeTitleLabel: UILabel!
  @IBOutlet weak var timeTextField: UITextField!
  
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!

  lazy var datePicker: UIDatePicker = {
    let dp = UIDatePicker()
    dp.datePickerMode = .date
    return dp
  }()
  lazy var timePicker: UIDatePicker = {
    let dp = UIDatePicker()
    dp.datePickerMode = .time
    return dp
  }()
  
  let disposeBag = DisposeBag()
  // MARK:- variables
  var navigator: DateSelectionNavigator
  var delegate: AddItemControllerDelegate?
  var date: Date?
  var hour = 0
  var minute = 0
  var repeatingInterval: RepeatingInterval?
  // MARK:- Constants
  let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "EEEE, MMM d, yyyy"
    return df
  }()
  let timeFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "HH:mm"
    return df
  }()
  //MARK:- Initialization
  init(navigator: DateSelectionNavigator) {
    self.navigator = navigator
    super.init(nibName: "DateSelectionController", bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK:- LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fillData()
    observeOnPickerChanges()
  }
  // MARK:- Actions
  @IBAction private func closeButtonPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  @IBAction private func deleteButtonPressed(_ sender: UIButton) {
    delegate?.deleteReminder()
    dismiss(animated: true, completion: nil)
  }
  @IBAction private func saveButtonPressed(_ sender: UIButton) {
    if let date = date, let repeatingInterval = repeatingInterval {
      delegate?.didSelectDateAndTime(date: date, hour: hour, minute: minute, repeatingInterval: repeatingInterval)
    }
    dismiss(animated: true, completion: nil)
  }
  @IBAction func repeatsSegmentControlValueChanged(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      repeatingInterval = RepeatingInterval.none
      showOrHideDateContainer(isHidden: false)
      dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
      
    case 1:
      repeatingInterval = .hourly
      showOrHideDateContainer(isHidden: true)
    case 2:
      repeatingInterval = .daily
      showOrHideDateContainer(isHidden: true)
    case 3:
      repeatingInterval = .weekly
      showOrHideDateContainer(isHidden: false)
      dateFormatter.dateFormat = "EEEE"
    case 4:
      repeatingInterval = .monthly
      showOrHideDateContainer(isHidden: false)
      dateFormatter.dateFormat = "d"

    case 5:
      repeatingInterval = .yearly
      showOrHideDateContainer(isHidden: false)
      dateFormatter.dateFormat = "EEEE, MMM d"
    default:
      print("Used undefined segment index")
    }
    if let date = date {
      changeTimeLabel(date: date)
      chageDateLabel(date: date)
    }
  }
  // MARK:- Functions
  private func showOrHideDateContainer(isHidden: Bool) {
    UIView.animate(withDuration: 0.25) { [dateContainerViewStackView] in
      dateContainerViewStackView?.isHidden = isHidden
    }
  }
  private func fillData() {
    if let passedDate = date {
      date = passedDate
      let timeFormatterString = self.timeFormatter.string(from: passedDate)
      let hourMinute = timeFormatterString.components(separatedBy: ":")
      if hourMinute.count == 2 {
        self.minute = Int(hourMinute[1]) ?? 0
        self.hour = Int(hourMinute[0]) ?? 0
      }
      saveButton.setTitle("update_button_title".localize(), for: .normal)
      deleteButton.isHidden = false
    } else {
      date = Date().addingTimeInterval(300)
      let timeFormatterString = self.timeFormatter.string(from: date!)
      let hourMinute = timeFormatterString.components(separatedBy: ":")
      if hourMinute.count == 2 {
        self.minute = Int(hourMinute[1]) ?? 0
        self.hour = Int(hourMinute[0]) ?? 0
      }
      deleteButton.isHidden = true
      saveButton.setTitle("save_button_title".localize(), for: .normal)
    }
    
    if let passedRepeats = repeatingInterval {
      repeatingInterval = passedRepeats
      if passedRepeats == .hourly || passedRepeats == .daily {
        showOrHideDateContainer(isHidden: true)
      }
    } else {
      repeatingInterval = RepeatingInterval.none
    }
    
    switch repeatingInterval {
    case .none:
      repeatsSegmentedControl.selectedSegmentIndex = 0
    case .hourly:
      repeatsSegmentedControl.selectedSegmentIndex = 1
    case .daily:
      repeatsSegmentedControl.selectedSegmentIndex = 2
    case .weekly:
      repeatsSegmentedControl.selectedSegmentIndex = 3
    case .monthly:
      repeatsSegmentedControl.selectedSegmentIndex = 4
    case .yearly:
      repeatsSegmentedControl.selectedSegmentIndex = 5
    default:
      print("Something went wrong in selecting repeating interval")
    }
    
    if let date = date {
      timePicker.setDate(date, animated: false)
      datePicker.setDate(date, animated: false)
    }
  }
  private func observeOnPickerChanges() {
    dateTextField.inputView = datePicker
    timeTextField.inputView = timePicker
    
    timePicker.rx.date.subscribe(onNext: { [changeTimeLabel] (date) in
      changeTimeLabel(date)
    }).disposed(by: disposeBag)
    
    datePicker.rx.date.subscribe(onNext: { [chageDateLabel] (date) in
      chageDateLabel(date)
    }).disposed(by: disposeBag)
  }
  
  private func changeTimeLabel(date: Date) {
    let timeFormatterString = timeFormatter.string(from: date)
    self.timeTextField.text = timeFormatterString
    let hourMinute = timeFormatterString.components(separatedBy: ":")
    if hourMinute.count == 2 {
      self.minute = Int(hourMinute[1]) ?? 0
      self.hour = Int(hourMinute[0]) ?? 0
    }
  }
  private func chageDateLabel(date: Date) {
    dateTextField.text = dateFormatter.string(from: date)
    if dateFormatter.dateFormat == "d" {
      let stringDate = dateFormatter.string(from: date)
      let dayTitle = "day_title".localize()
      let ofMonthTitle = "of_month_title".localize()
      if stringDate == "1" {
        dateTextField.text = "\(stringDate)st \(dayTitle) \(ofMonthTitle)"
      } else if stringDate == "2" {
        dateTextField.text = "\(stringDate)nd \(dayTitle) \(ofMonthTitle)"
      } else {
        dateTextField.text = "\(stringDate)th \(dayTitle) \(ofMonthTitle)"
      }
    }
    let newDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: date) ?? Date()
    self.date = newDate
  }
}
