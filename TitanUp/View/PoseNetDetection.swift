//
//  PoseNetDetection.swift
//  TitanUp
//
//  Created by Huw Williams on 14/11/2024.
//

import SwiftUI

struct PoseNetDetection: View {
    
    @StateObject var viewModel = PoseNetDetectionViewModel()

    var body: some View {
        HStack {
            CustomTextField(
                placeholder: "pushups",
                text: Binding(
                    get: { String(viewModel.pushupCount) }, // Convert Int to String for display
                    set: { viewModel.pushupCount = Int($0) ?? 0 } // Convert String back to Int
                )
            )
            Button {
                viewModel.saveSessionToFirestore()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 150, height: 60)
                    Text("Return")
                        .foregroundStyle(Color.white)
                        .font(.title)
                }
            }
        }
    }
}


#Preview {
    PoseNetDetection()
}
