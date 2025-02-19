// HomeView.swift
// TitanUp

import SwiftUI
import Charts
import FirebaseFirestore
import FirebaseAuth

// HomeView
struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel() // Single instance of the ViewModel
    
    
    var body: some View {
        BackgroundImage {
            VStack(alignment: .center, spacing: 10) {
                
                ProfilePanel(colour: Color.titanUpBlue)
                TwoChartPanels(colour: Color.panelColour)
                LongChartPanel(colour: Color.panelColour)
                MedalPanel(colour: Color.panelColour)
                Spacer()
            }
            
        }
        .environmentObject(viewModel) // Pass the ViewModel to the environment
    }
}

#Preview {
    HomeView()
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
                                .foregroundStyle(getRandomColor(value: session.pushUps))
                                                        
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
                        BarMark(x: .value("Date", session.date, unit: .day),
                                y: .value("push ups", session.pushUps),
                                width: 15
                        )
                        .foregroundStyle(getRandomColor(value: session.pushUps))
                    }
                    .padding()
                    .chartXAxis(.hidden)
                    .chartYScale(domain: 0...100) // height of Y axis
                    .animation(.bouncy, value: viewModel.weekSessions)
                    
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
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(colour)
                .frame(width: UIScreen.main.bounds.width)
            
            if viewModel.monthSessions.isEmpty {
                Text("No Sessions")
            } else {
                // still trying to work this chart out.
                Chart(viewModel.monthSessions) { session in
                    BarMark(x: .value("Date", session.date, unit: .day),
                            y: .value("push ups", session.pushUps),
                            width: 15
                    )
                    .foregroundStyle(getRandomColor(value: session.pushUps))
                }
                .padding()
                .chartXAxis(<#Visibility#>)
                .chartYScale(domain: 0...100) // height of Y axis
                .animation(.bouncy, value: viewModel.monthSessions)
            }
            
        }
        .frame(height: UIScreen.main.bounds.height * 0.2)
        
    }
}

// MedalPanel
struct MedalPanel: View {
    let width: CGFloat = 90
    let height: CGFloat = 90
    let colour: Color
    
    var body: some View {
        Grid() {
            GridRow {
                Image("medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(0.6)
                    .cornerRadius(15)
                    
                Image("medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(0.6)
                    .cornerRadius(15)
                
                Image("medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(0.6)
                    .cornerRadius(15)
                
                Image("medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(0.6)
                    .cornerRadius(15)
            }
            GridRow {
                Image("medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(0.6)
                    .cornerRadius(15)
                
                Image("medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(0.6)
                    .cornerRadius(15)
                
                Image("medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(0.6)
                    .cornerRadius(15)
                
                Image("medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(0.6)
                    .cornerRadius(15)
            }
            
            
        }
        
        
    }
}

// gives the colours to the charts.
func getRandomColor(value: Int) -> Color {
    
    if value <= 10 {
        return .titanUpBlue
    }
    if value <= 15 {
        return .titanUpMidBlue
    }
    if value <= 20 {
        return Color.blue
    }
    else {
        return .gray
        
    }
}


