//
//  HomeView.swift
//  TitanUp
//
//  Created by Huw Williams on 05/11/2024.
//

import SwiftUI
import Charts
import FirebaseFirestore
import FirebaseAuth
// 1. Layout structure (widgets are below preview)
struct HomeView: View {
    let userId: String
    
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        BackgroundImage {
            VStack {
                // pass viewmodel and firenase query)
                ProfilePanel(colour: Color.titanUpBlue, viewModel: viewModel)
                    
                TwoChartPanels(colour: Color.panelColour, viewModel: viewModel)
                
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
    @ObservedObject var viewModel: HomeViewModel
    let colour: Color
    // firebase query
    init(colour: Color, viewModel: HomeViewModel) {
        self.colour = colour
        self.viewModel = viewModel
    }
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
    @StateObject var viewModel = HomeViewModel()
    
    
    var body: some View {
        
        HStack {
            ZStack {
                
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(colour)
                if viewModel.sessions.isEmpty {
                    Text("No Sessions")
                } else {
                    var today = viewModel.filterSessionsForToday(sessions: viewModel.sessions)
                    Chart(today) {session in
                        SectorMark(angle: .value("reps", session.pushUps ), innerRadius: .ratio(0.3), angularInset: 1.2)
                            .cornerRadius(5)
                            
                    }
                }
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.6)
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(colour)
                // weekly bar chart (7 days
                if viewModel.sessions.isEmpty {
                    Text("No Sessions")
                } else {
                    let sevendays = viewModel.filterSessionsFor7Days(sessions: viewModel.sessions)
                    Chart(sevendays) { session in
                        BarMark(x: .value("date", session.date),
                                y: .value ("push ups", session.pushUps))
                    }
                    .padding()
                }
                
                    
            }
            .frame(width: UIScreen.main.bounds.width * 0.4)
        }
        .frame(height: UIScreen.main.bounds.height * 0.2)
        // bar chart date formatter
        
    }
    private func formmatedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
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
