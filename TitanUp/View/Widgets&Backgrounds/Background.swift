//
//  Background.swift
//  TitanUp
//
//  Created by Huw Williams on 05/11/2024.
//

import SwiftUI

// this is the logic for the BackgroundImge.
// it lets you attach the stylised image that is in the background.
// just use `.BackgroundImage` on any Stack.
import SwiftUI

struct BackgroundImage<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            // Background Image
            Image("background")
                .resizable()
                .frame(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.height + 100)
                .offset(x: 90, y: -50)

            // Main Content
            content
        }
    }
}




