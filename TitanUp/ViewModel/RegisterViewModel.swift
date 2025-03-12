//
//  RegisterViewModel.swift
//  TitanUp
//
//  Created by Huw Williams on 19/11/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterViewModel: ObservableObject {
    @Published var name = "";
    @Published var password = "";
    @Published var checkPassword = ""
    @Published var email = "";
    @Published var errorMessage = "";
    
    func register() {
        // validate input
        guard validate() else {
            return;
        }
        // create a new user in the database.
        Auth.auth().createUser(withEmail: email, password: password){ [weak self] result, error in
            guard let userId = result?.user.uid else {
                return;
            }
            self?.insertUser(id: userId);
        }
    }
    
     func insertUser(id:String){
        // creates new users and inputs fields.
        let newUser = User(id: id,
                           name: self.name,
                           email: self.email,
                           Joined: Date().timeIntervalSince1970);
        // accesses db
        let db = Firestore.firestore();
        // calls the collection and sets data.
        db.collection("TitanUpUsers")
            .document(id)
            .setData(newUser.asDictionary()) // extension is in Model    }
        
    }
    
    // user input error handling.
    func validate() -> Bool {
        self.errorMessage = "";
        // checks input - name, email and passowrd hold characters.
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.errorMessage = "please enter login details.";
            return false;
        }
        // ensures that email is an email address.
        guard email.contains("@") && email.contains(".") else {
            self.errorMessage = "Please enter a valid email.";
            return false;
        }
        // asks for 6 characters.
        guard password.count >= 6 else {
            self.errorMessage = "Please enter a Password 6 or more characters.";
            return false
        }
        guard password == checkPassword else {
            self.errorMessage = "Passwords do not match. Try again.";
            return false;
        }
        
        return true
    }
}
