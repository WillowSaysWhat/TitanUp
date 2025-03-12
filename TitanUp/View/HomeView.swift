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
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.titanUpMidBlue, Color.titanUpBlue]), // Customize colors
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

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
                
                // trophy grid
                Grid() {
                    GridRow {
                        Image(viewModel.medalsTrophies.oneSession ? "Trophy1" : "trophyPlaceholder")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .opacity(viewModel.medalsTrophies.oneSession ? 1 : 0.6)
                            .cornerRadius(15)
                            
                        
                        Image(viewModel.medalsTrophies.twoSession ? "Trophy2" : "trophyPlaceholder")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .opacity(viewModel.medalsTrophies.twoSession ? 1 : 0.6)
                            .cornerRadius(15)
                        
                        Image(viewModel.medalsTrophies.fiveSession ? "Trophy3" : "trophyPlaceholder")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .opacity(viewModel.medalsTrophies.fiveSession ? 1 : 0.6)
                            .cornerRadius(15)
                    }
                    GridRow {
                        Image(viewModel.medalsTrophies.eightSession ? "Trophy9" : "trophyPlaceholder")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .opacity(0.6)
                            .cornerRadius(15)
                        
                        Image(viewModel.medalsTrophies.tenSession ? "Trophy4" : "trophyPlaceholder")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .opacity(0.6)
                            .cornerRadius(15)
                        
                        Image(viewModel.medalsTrophies.fifteenSession ? "Trophy5" : "trophyPlaceholder")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .opacity(0.6)
                            .cornerRadius(15)
                    }
                }
                .offset(x: UIScreen.main.bounds.width * 0.22,
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
                if $viewModel.todaySessions.isEmpty {
                    Text("No Sessions")
                } else {
                    Chart(viewModel.todaySessions) { session in
                        
                            SectorMark(angle: .value("reps", session.pushUps), innerRadius: .ratio(0.3), angularInset: 1.2)
                                .cornerRadius(5)
                                .foregroundStyle(RadialGradient(
                                    gradient: Gradient(colors: [.blue, getRandomColor(value: session.pushUps)]),
                                    center: .leading,
                                    startRadius: 5,
                                    endRadius: 100
                                )
                            )
                                                        
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
                        .foregroundStyle(LinearGradient(
                            gradient: Gradient(colors: [.blue, getRandomColor(value: session.pushUps)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                      )
                    }
                    .padding()
                    .chartXAxis(.hidden)
                    .chartYScale(domain: 0...200) // height of Y axis
                    .animation(.bouncy, value: viewModel.weekSessions)
                    
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.4, height:UIScreen.main.bounds.height * 0.2)
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
            
            if $viewModel.monthSessions.isEmpty {
                Text("No Sessions")
            } else {
                // still trying to work this chart out.
                Chart(viewModel.monthSessions) { session in
                    BarMark(x: .value("Date", session.date, unit: .day),
                            y: .value("push ups", session.pushUps),
                            width: 18
                    )
                    .foregroundStyle(getRandomColor(value: session.pushUps))
                    
                }
                .padding()
                .chartYScale(domain: 0...200) // height of Y axis
                .animation(.bouncy, value: viewModel.monthSessions)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.2)
            }
            
        }
        .frame(height: UIScreen.main.bounds.height * 0.2)
        
    }
}

// MedalPanel
struct MedalPanel: View {
    @EnvironmentObject var viewModel: HomeViewModel
    let width: CGFloat = 90
    let height: CGFloat = 90
    let colour: Color
    
    var body: some View {
        Grid() {
            GridRow {
                Image(viewModel.medalsTrophies.firstDay ? "Medal1" :"medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(viewModel.medalsTrophies.firstDay ? 1 : 0.6)
                    .cornerRadius(15)
                    
                Image(viewModel.medalsTrophies.seventhDay ? "Medal2" :"medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(viewModel.medalsTrophies.seventhDay ? 1: 0.6)
                    .cornerRadius(15)
                
                Image(viewModel.medalsTrophies.thirtyDay ? "Medal3" : "medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(viewModel.medalsTrophies.thirtyDay ? 1: 0.6)
                    .cornerRadius(15)
                
                Image(viewModel.medalsTrophies.sixtyDay ? "Medal4" : "medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(viewModel.medalsTrophies.sixtyDay ? 1 : 0.6)
                    .cornerRadius(15)
            }
            GridRow {
                Image(viewModel.medalsTrophies.ninetyDay ? "Medal5" : "medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(viewModel.medalsTrophies.ninetyDay ? 1 : 0.6)
                    .cornerRadius(15)
                
                Image(viewModel.medalsTrophies.OneFiftyDay ? "Medal6" : "medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(viewModel.medalsTrophies.OneFiftyDay ? 1 : 0.6)
                    .cornerRadius(15)
                
                Image(viewModel.medalsTrophies.twoHundredDay ? "Medal7" :"medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(viewModel.medalsTrophies.twoHundredDay ? 1 : 0.6)
                    .cornerRadius(15)
                
                Image(viewModel.medalsTrophies.threeHundredDay ? "Medal8" :"medalPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .opacity(viewModel.medalsTrophies.threeHundredDay ? 1 : 0.6)
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
        return .titanUpLightBlue
    }
    if value <= 30 {
        return .titanUpMidBlue
    }
    if value <= 40 {
        return .titanUpLightBlue
        
    }
    else {
        return .titanUp
        
    }
}


