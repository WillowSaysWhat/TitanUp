//
//  ContentView.swift
//  TitanUp
//
//  Created by Huw Williams on 12/08/2024.
//

import SwiftUI

struct ContentView: View {
    let isSignedIn = true
    var body: some View {
        
        BackgroundImage{
            
            if isSignedIn {
                HomeTabView
            } else {
                //Login()
            }
        }
        
        
    }
}

@ViewBuilder
var HomeTabView: some View {
    NavigationView { // Step 1: Wrap in NavigationView
        
        BackgroundImage{
            TabView {
                    // HomePage
                    
                    // MedalPage
                    
                    // ProfilePage
            }
        }
        
    }
}

#Preview {
    ContentView()
}
