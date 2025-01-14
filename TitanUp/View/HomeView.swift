// HomeView.swift
// TitanUp

import SwiftUI
import Charts
import FirebaseFirestore
import FirebaseAuth

// HomeView
struct HomeView: View {
    let userId: String
    @StateObject var viewModel = HomeViewModel() // Single instance of the ViewModel
    
    var body: some View {
        BackgroundImage {
            VStack {
                ProfilePanel(colour: Color.titanUpBlue) // No need to pass the viewModel explicitly
                TwoChartPanels(colour: Color.panelColour)
                LongChartPanel(colour: Color.panelColour)
                MedalPanel(colour: Color.panelColour)
            }
        }
        .environmentObject(viewModel) // Pass the ViewModel to the environment
    }
}

#Preview {
    HomeView(userId: "P83CGGUVLnUFB6v9uZ4XDhM2DeD2")
}

// ProfilePanel
struct ProfilePanel: View {
    let colour: Color
    @EnvironmentObject var viewModel: HomeViewModel // Use environment object
    
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

// TwoChartPanels
struct TwoChartPanels: View {
    let colour: Color
    @EnvironmentObject var viewModel: HomeViewModel // Use environment object
    @State private var PieIsAnimated: Bool = false
    @State private var animatedData: [Session] = []
    @State private var pieTrigger: Double = 0
    @State private var barTrigger: Double = 0
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(colour)
                if viewModel.todaySessions.isEmpty {
                    Text("No Sessions")
                } else {
                    Chart(viewModel.todaySessions) { session in
                        
                            SectorMark(angle: .value("reps", session.pushUps), innerRadius: .ratio(0.3), angularInset: 1.2)
                                .cornerRadius(5)
                        
                    }
                    .opacity(pieTrigger)
                    .onAppear() {
                        withAnimation(.linear(duration: 1.5)){
                            pieTrigger = 1
                        }
                    }
                    
                    
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.6)
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(colour)
                if viewModel.weekSessions.isEmpty {
                    Text("No Sessions")
                } else {
                    Chart(viewModel.weekSessions) { session in
                        BarMark(x: .value("date", session.date),
                                y: .value("push ups", session.pushUps))
                    }
                    .padding()
                    .opacity(barTrigger)
                    .onAppear {
                        withAnimation(.linear(duration: 2)){
                            barTrigger = 1
                        }
                    }
                    
                    
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.4)
        }
        .frame(height: UIScreen.main.bounds.height * 0.2)
    }
} // end of view


// LongChartPanel
struct LongChartPanel: View {
    let colour: Color
    @EnvironmentObject var viewModel: HomeViewModel // Use environment object
    @State private var trigger: Double = 0
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(colour)
                .frame(width: UIScreen.main.bounds.width)
            
            if viewModel.monthSessions.isEmpty {
                Text("No Sessions")
            } else {
                Chart(viewModel.monthSessions) { session in
                    BarMark(x: .value("date", session.date),
                            y: .value("push ups", session.pushUps))
                }
                .padding()
                .opacity(trigger)
                .onAppear() {
                    withAnimation(.linear(duration: 3.5)) {
                        trigger = 1
                    }
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.2)
    }
}

// MedalPanel
struct MedalPanel: View {
    let colour: Color
    
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
