# Widgets and Backgrounds.

Rather than trying to reuse the image code on every View. An `extension` was built instead.

```swift
import SwiftUI

// this is the logic for the BackgroundImge extension.
// it lets you attach the stylised image that is in the background.
// just use `.BackgroundImage` on any Stack.
struct BackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            // Background Image
            Image("yourImageName")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            // Foreground Content
            content
        }
    }
}

// this is the extension name. 
extension View {
    func backgroundImage() -> some View {
        self.modifier(BackgroundModifier())
    }
}

```