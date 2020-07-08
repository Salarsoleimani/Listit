//
//  ViewModelType.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import Foundation

public protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  func transform(input: Input) -> Output
}
