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

