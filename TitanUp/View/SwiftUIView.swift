//
//  SwiftUIView.swift
//  TitanUp
//
//  Created by Huw Williams on 10/02/2025.
//

import SwiftUI

struct TodaySessionsListView: View {
    @StateObject var viewModel = HomeViewModel() // ✅ Access ViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.weekSessions) { session in
                        VStack {
                            Text(session.date, style: .date)
                            Text("Push-ups: \(session.pushUps)")
                        }
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
            }

        }
    }
}

#Preview {
    TodaySessionsListView()
        
}
