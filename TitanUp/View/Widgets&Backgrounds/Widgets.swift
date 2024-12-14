//
//  Widgets.swift
//  TitanUp
//
//  Created by Huw Williams on 14/11/2024.
//

import SwiftUI

// Button widget that returns a view as an alias Destination <Destination: View>
// It is used as a refactoring of buttons throughout the app.
struct LoginButton<Destination: View>: View {
    var name: String
    var width: Double
    var height: Double
    var colour: Color
    var destination: Destination
    var  font: Font
    
    var body: some View {
        
        NavigationLink(destination: destination){
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: width, height: height)
                    .foregroundStyle(colour)
                Text(name)
                    .foregroundStyle(Color.white)
                    .font(font)
            }
        }
    }
}


struct CustomTextField: View {
    
    let placeholder: String
    
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white.opacity(0.5))
            .cornerRadius(10)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .shadow(radius: 5)
            
    }
}

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color.white.opacity(0.5))
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}
