//
//  ProfileView.swift
//  TitanUp
//
//  Created by Huw Williams on 05/11/2024.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    var body: some View {
        Text("Profile View")
        Button {
                        
                do {
                 try Auth.auth().signOut()
                            
                }catch {
                    print(error)
                }
        }label: {
            Text("sign out")
        }
    }
}

#Preview {
    ProfileView()
}
