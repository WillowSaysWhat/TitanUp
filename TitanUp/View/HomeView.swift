//
//  HomeView.swift
//  TitanUp
//
//  Created by Huw Williams on 05/11/2024.
//

import SwiftUI
import Charts
// 1. Layout structure (widgets are below preview)
struct HomeView: View {
    
    // make a Firebase query here and pass it with viewModel
    // to panels
    init(userId: String){
        
    }
    
    var body: some View {
        BackgroundImage {
            VStack {
                // pass viewmodel and firenase query)
                ProfilePanel(colour: Color.titanUpBlue)
                    
                TwoChartPanels(colour: Color.panelColour)
                
                LongChartPanel(colour: Color.panelColour)
                
                MedalPanel(colour: Color.panelColour)
            }
        }
    }
}

#Preview {
    HomeView(userId: "P83CGGUVLnUFB6v9uZ4XDhM2DeD2")
}
//
//
//
// panels start here
//
// top profile panel
struct ProfilePanel: View {
    let colour: Color
    // firebase query
var body: some View {
    ZStack {
        RoundedRectangle(cornerRadius: 15)
            .foregroundStyle(colour)
        Circle()
            .frame(width: 130)
            .offset(x: UIScreen.main.bounds.width * -0.29,
                    y: UIScreen.main.bounds.height * 0.05)
            .foregroundStyle(Color.titanUpMidBlue)
        
        Image("viking")
            .resizable()
            .scaledToFit()
            .frame(width: 120)
            .clipShape(Circle())
            .offset(x: UIScreen.main.bounds.width * -0.29,
                    y: UIScreen.main.bounds.height * 0.05)
        }
    .frame(height: UIScreen.main.bounds.height * 0.30)
    }
}
//
// middle column panel with charts
struct TwoChartPanels: View {
    let colour: Color
    // firebase query
    var body: some View {
        
        HStack {
            ZStack {
                // daily pushup pie chart (num unknown)
                // make colour changing functionality.
                // Not finished (mock)
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(colour)
               

            }
            .frame(width: UIScreen.main.bounds.width * 0.6)
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(colour)
                // weekly bar chart (7 days
                Chart {
                    // This is not a finished Chart (Mock)
                    BarMark(x: .value("Type", "M"),
                            y: .value("Population", 10))
                    .foregroundStyle(Color.titanUpMidBlue)
                    
                    BarMark(x: .value("Type", "Tu"),
                            y: .value("Population", 9))
                    .foregroundStyle(Color.titanUpMidBlue)
                    
                    BarMark(x: .value("Type", "W"),
                            y: .value("Population", 11))
                    .foregroundStyle(Color.titanUpMidBlue)
                    
                    BarMark(x: .value("Type", "T"),
                            y: .value("Population", 11))
                    .foregroundStyle(Color.titanUpMidBlue)
                    
                    BarMark(x: .value("Type", "F"),
                            y: .value("Population", 12))
                    .foregroundStyle(Color.titanUpMidBlue)
                    
                    BarMark(x: .value("Type", "S"),
                            y: .value("Population", 1))
                    .foregroundStyle(Color.titanUpMidBlue)
                    BarMark(x: .value("Type", "Su"),
                            y: .value("Population", 1))
                    .foregroundStyle(Color.titanUpMidBlue)




                }
                .aspectRatio(contentMode: .fit)
                .padding()
                
                    
            }
            .frame(width: UIScreen.main.bounds.width * 0.4)
        }
        .frame(height: UIScreen.main.bounds.height * 0.2)
        
    }
}
    //
    // long bar chart for monthly display
    struct LongChartPanel: View {
        let colour: Color
        // firebase query
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(colour)
                    .frame(width: UIScreen.main.bounds.width)
                
                
            }
            .frame(height: UIScreen.main.bounds.height * 0.2)
        }
    }
    //
    // medal bar at the bottom.
    struct MedalPanel: View{
        let colour: Color
        // view model
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .opacity(0.3)
                    .foregroundStyle(colour)
                    .frame(width: UIScreen.main.bounds.width)
            }
            .frame(height: UIScreen.main.bounds.height * 0.4)
    }
}
