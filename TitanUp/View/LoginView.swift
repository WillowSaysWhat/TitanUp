//
//  LoginView.swift
//  TitanUp
//
//  Created by Huw Williams on 05/11/2024.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    // access to view model.
    @StateObject var viewModel = LoginViewModel()
    var body: some View {
        // custom container that has a VStack and an Image.
        BackgroundImage {
              // aligns the 2 fields and button vertically.
            VStack(spacing: 20) {
                // displays error message.
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
                // Title
                Text("Welcome Back!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                // Email
                CustomTextField(placeholder: "email", text: $viewModel.email)
                
                
                // Password
                CustomSecureField(placeholder: "Password", text: $viewModel.password)
                
                
                // Login Button
                Button(action: {
                    viewModel.login()
                    dismiss()
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.titanUpBlue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 10)
                
            }
            .padding()
            .frame(maxWidth: 400) // Limit width of container.
        }
    }
}
#Preview {
    LoginView()
}


