//
//  RegisterView.swift
//  TitanUp
//
//  Created by Huw Williams on 14/11/2024.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    var body: some View {
        BackgroundImage {
            VStack(spacing: 20) {
                // Title
                Text("Welcome")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                // user name.
                CustomTextField(placeholder: "name", text: $viewModel.name)
                // email.
                CustomTextField(placeholder: "email", text: $viewModel.email)
                
                // Password.
                CustomSecureField(placeholder: "Password", text: $viewModel.password)
                // check password.
                CustomSecureField(placeholder: "Check Password", text: $viewModel.checkPassword)
                
                // Login Button.
                Button(action: {
                    viewModel.register();
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
                // displays error messge under button
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding()
            .frame(maxWidth: 400) // Limit width for better responsiveness
        }
    }
}

#Preview {
    RegisterView()
}
