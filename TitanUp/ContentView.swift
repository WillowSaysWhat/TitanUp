//
//  ContentView.swift
//  TitanUp
//
//  Created by Huw Williams on 12/08/2024.
// password: willow123

import SwiftUI

struct ContentView: View {
    @StateObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if contentViewModel.isSignedIn {
                    HomeTabView(uid: contentViewModel.currentUserId)
                } else {
                    StartView()
                    
                }
            }
            .onAppear {
                print("ContentView appeared. Current User ID: \(contentViewModel.currentUserId)")
            }
        }
    }
}


struct HomeTabView: View {
    var uid: String
    
    var body: some View {
        if !uid.isEmpty {
            ZStack {
                TabView {
                    HomeView()
                        .tabItem { Label("home", systemImage: "clock") }
                    ProfileView()
                        .tabItem { Label("profile", systemImage: "person") }
                }
                .background(Color.titanUpMidBlue)
                
                VStack {
                    Spacer()
                    NavigationLink(destination: FrontCameraView()) {
                        ZStack {
                            Circle()
                                .frame(width: 60)
                                .foregroundStyle(Color.titanUpBlue)
                            Circle()
                                .frame(width: 50)
                        }
                    }
                }
            }
        } else {
            Text("Loading user data...")
                .onAppear {
                    print("HomeTabView: UID is empty.")
                }
        }
    }
}


#Preview {
    ContentView()
        
}
