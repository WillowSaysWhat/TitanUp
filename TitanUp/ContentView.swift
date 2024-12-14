//
//  ContentView.swift
//  TitanUp
//
//  Created by Huw Williams on 12/08/2024.
// password: willow123

import SwiftUI

struct ContentView: View {
    // access to view model
    @StateObject var contentViewModel = ContentViewModel()
    var body: some View {
        // if the user is logged in go to Tab View,
        // otherwise go to the start View.
            if contentViewModel.isSignedIn, !contentViewModel.currentUserId.isEmpty {
                HomeTabView(uid: contentViewModel.currentUserId)
            } else {
                //StartView()
                HomeTabView(uid: contentViewModel.currentUserId)
            }
        
    }
}

struct HomeTabView: View {
    @State var uid: String
    var body: some View {
        
        ZStack {
            TabView {
                HomeView(userId: uid)
                    .tabItem { Label("home", systemImage: "clock") }
                    
                // MedalPage
                
                ProfileView()
                    .tabItem { Label("prifile", systemImage: "person") }
            }
            .background(Color.titanUpMidBlue)
            VStack {
                Spacer()
                NavigationLink(destination: PoseNetDetection()){
                    ZStack{
                        Circle()
                            .frame(width: 80)
                            .foregroundStyle(Color.titanUpBlue)
                        Circle()
                            .frame(width: 70)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        
}
