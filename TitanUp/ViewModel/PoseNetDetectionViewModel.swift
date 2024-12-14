//
//  PoseNetDetectionViewModel.swift
//  TitanUp
//
//  Created by Huw Williams on 20/11/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


class PoseNetDetectionViewModel: ObservableObject {
    @Published var pushupCount: Int = 0
    
    private func getUserId() -> String {
        if let user = Auth.auth().currentUser {
            return user.uid
        }else {
            print("no user is currently signed in")
            return ""
        }
        
    }
    
    
    func saveSessionToFirestore() {
        let uid = getUserId() // Get the user ID
        
        let db = Firestore.firestore()
        
        // Create a new session object
        let newSession = Session(date: Date.now, pushUps: pushupCount)
        
        // Convert the session object to a dictionary
        let sessionData = newSession.asDictionary()
        
        // Reference the "DailySessions" collection for the user
        let userSessionsCollection = db.collection("TitanUpUsers")
            .document(uid)
            .collection("DailySessions")
        
        // Add a new document with auto-generated ID
        userSessionsCollection.addDocument(data: sessionData) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("New session document created successfully!")
            }
        }
        
    }
}
