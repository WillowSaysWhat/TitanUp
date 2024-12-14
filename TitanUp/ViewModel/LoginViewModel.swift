//
//  LoginViewModel.swift
//  TitanUp
//
//  Created by Huw Williams on 05/11/2024.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = "";
    @Published var password = "";
    @Published var errorMessage = "";
    
    
    func login() {
        guard validate() else {
            return;
        }
        Auth.auth().signIn(withEmail: email, password: password);
    }
    
    // this checks that a passweord as been empty and an actual email is entered.
    private func validate() -> Bool{
        
        self.errorMessage = ""
        
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "please enter login details.";
            return false;
        }
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "please enter a valid email."
            return false;
        }
        return true;
    }
}

