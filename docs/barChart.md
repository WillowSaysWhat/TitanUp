# bar Chart for SwiftUI

This is how I will make the bar graph for the home page. This is a tutorial from YT video SwiftUI bar Chart with Customizations | Swift Charts - https://www.youtube.com/watch?v=4utsyqhnS4g

```swift


import SwiftUI

struct ContentView: View {
    let viewMonths: [ViewMonth] = [
    .init(date: Date.from(year:2023, month: 1, day: 1), viewCount: 55000)
    // there are 11 more of these to make the 12 month array.
]
var body: some View {
    VStack {
        
    }
}

}




struct ViewMonth: Identifiable {
    let id = UUID()
    let date: Date
    let viewCount: Int
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = dateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}

```