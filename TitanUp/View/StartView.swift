//
//  StartView.swift
//  TitanUp
//
//  Created by Huw Williams on 05/11/2024.
//

import SwiftUI

struct StartView: View {
    @State var viewModel = StartViewModel()
    var body: some View {
            BackgroundImage {
                VStack {
                   // Add TitanUp Title Banner image
                    
                    LoginButton(name: "Login", width: 210, height: 60, colour: Color.titanUpBlue, destination: LoginView(), font: .title)
                        .offset(CGSize(width: 0, height: viewModel.ScreenHeight * 0.25))
                    LoginButton(name: "Register", width: 210, height: 60, colour: Color.titanUpBlue, destination: RegisterView(), font: .title)
                        .offset(CGSize(width: 0, height: viewModel.ScreenHeight * 0.25))
                    }
                }
                
            }
        }
    


#Preview {
    StartView()
}


