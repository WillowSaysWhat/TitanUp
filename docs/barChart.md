<p align="center">
<img src="/docs/assets/barChartHeading.jpg"/>
</p>

<p align="justify">
This is how I will make the bar graph for the home page. This is a tutorial from YT video SwiftUI bar Chart with Customizations | Swift Charts - https://www.youtube.com/watch?v=4utsyqhnS4g

TitanUp will have two bar charts. one will display daily push-ups over seven days and a monthly bar chart. the monthly chart will be a vertical bar chart and the smaller chart will be horizonal.
</p>

```swift


import SwiftUI
import Charts

struct ContentView: View {
    let viewMonths: [ViewMonth] = [
    .init(date: Date.from(year:2023, month: 1, day: 1), viewCount: 55000)
    // there are 11 more of these to make the 12 month array.
]
var body: some View {
    VStack {
        Chart {
            ForEach(viewMonths) viewMonth in
              Barmark( // flip the x and y info to get a vertical bar chart.
                x: .value("Month", viewMonth.date, unit:.month), 
                y: .value("Views", viewMonth.viewCount)
              )  

        }
        .frame(height: 180)
    }
    .padding()
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