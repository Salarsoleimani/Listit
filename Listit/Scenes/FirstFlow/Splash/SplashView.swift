//
//  SplashView.swift
//  Listit
//
//  Created by Salar Soleimani on 2024-04-15.
//  Copyright © 2024 SaSApps. All rights reserved.
//

import SwiftUI

struct SplashView: View {
  
  @StateObject var viewModel: SplashViewModel
  
  var body: some View {
    
    VStack(spacing: 40) {
      Spacer()
      
      loginToIcloudView
        .opacity(viewModel.userId == nil ? 1 : 0)
        .scaleEffect(viewModel.userId == nil ? 1 : 0.1)
        .animation(.spring(), value: viewModel.userId == nil)
      
      ProgressView()
        .foregroundColor(Colors.title.value)
        .opacity(viewModel.toHome == true ? 1 : 0)
      
      Text("splash-description".localize())
        .foregroundColor(Colors.title.value)
        .font(Fonts.h5Regular)
    }
    
    .padding()
    .overlay {
      ZStack {
        VStack(spacing: 12) {
          logoImageView
          logoTextView
        }
        .offset(y: viewModel.logoImageAnimate ? -32 : 8)
      }
      .frame(height: .deviceHeight)
      .ignoresSafeArea()
    }
    .onChange(of: viewModel.toHome, perform: { newValue in
      if newValue {
        viewModel.goToHomePage()
      }
    })
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
      viewModel.viewAppeared()
    }
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { (_) in
      viewModel.resetView()
    }
    .onAppear {
      viewModel.viewAppeared()
    }
  }
  var loginToIcloudView: some View {
    VStack(spacing: 12) {
      Text("splash-logindesc")
        .font(Fonts.itemCellTitle)
        .foregroundColor(Colors.title.value)
        .multilineTextAlignment(.center)
      
      Button {
        Utility.openURL(url: UIApplication.openSettingsURLString)
      } label: {
        Text("splash-loginbutton")
          .font(Fonts.itemCellTitle)
          .foregroundColor(Colors.white.value)
          .padding()
          .background(RoundedRectangle(cornerRadius: Constants.Radius.cornerRadius).foregroundColor(Colors.main.value))
      }
    }
  }
  
  var logoImageView: some View {
    Image("Logo")
      .resizable()
      .frame(width: viewModel.width, height: viewModel.width)
      .scaleEffect(viewModel.logoImageAnimate ? 1.1 : 1)
      .animation(.spring(), value: viewModel.logoImageAnimate)
  }
  
  var logoTextView: some View {
    let font = SSFont(.installed(.montserrat, .bold), size: .custom(33)).instance
    return Text("Listit")
      .font(font)
      .foregroundColor(Colors.title.value)
      .opacity(viewModel.logoTextAnimate ? 1 : 0)
      .scaleEffect(viewModel.logoTextAnimate ? 1 : 0.1)
      .animation(.spring(), value: viewModel.logoTextAnimate)
  }
}
