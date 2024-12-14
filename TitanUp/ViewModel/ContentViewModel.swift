//
//  ContentViewModel.swift
//  TitanUp
//
//  Created by Huw Williams on 18/11/2024.
//

import Foundation
import FirebaseAuth

class ContentViewModel: ObservableObject {
    @Published var currentUserId: String = "";
    @Published var showingNewItemView = false;
    @Published var isSheet = false;
    
    // listener that updates the app when changes are made.
    private var handler: AuthStateDidChangeListenerHandle?;
    
    // dictates whether the ContentView displays the Login or the Content TabView.
    public var isSignedIn: Bool {
        Auth.auth().currentUser != nil
    }
    
    init() { // initialises the listener and places the user ID into the currentUserId variable.
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? "";
            }
        }
    }
    
    
    
    
}
