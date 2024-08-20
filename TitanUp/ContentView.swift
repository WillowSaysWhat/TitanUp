//
//  ContentView.swift
//  TitanUp
//
//  Created by Huw Williams on 12/08/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView { // Step 1: Wrap in NavigationView
            VStack {
                NavigationLink(destination: FrontCameraView()) { // Step 2: Use NavigationLink
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50)
                            .shadow(radius: 5)
                        Text("Camera")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
