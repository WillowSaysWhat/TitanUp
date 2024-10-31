# SwiftUI Pie Charts iOS 17

This is the SwiftUI pie chart that will be used in TitanUp. This comes from the YT tutorial SwiftUI Pie and Dounut charts - New to iOS 17 - https://www.youtube.com/watch?v=8M3N4HWUc0U
First accessed 31 October 2024.

## Objects needed

```swift
// this is an example of converting the original bar chart data into other data
struct ConvertedChartData: Identifiable, Equatable {
    let id = UUID()
    var value: Double
    var date: Date
}

struct StackedBarChartData: Identifiable, Equatable {
    let id = UUID()
    var value: Double
    var date: Date
    var type: String
}

```

The two example above are very simple structs that can be used to input data into the pie chart
Below the view struct are two. one is an object blueprint and the other is a struct with a list of mockdata to help visualise the pie chart.

```swift
import SwiftUI
import Charts

// visualising the pie chart
struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Chart {
                    ForEach(MockData.revenueStreams) { stream in
                        Sectormark(angle: .value("Stream", value: stream.value), 
                        innerRadius: .ratio(0.618), // 1
                        outerRadius: stream.name == "Sponsors" ? 180 : 120, // 2
                        angualarInset: 1.0)
                            .forgroundStyle(stream.colour)
                            .cornerRadius(4) // adds a curve to each slice
                    }
                }
                .chartLegend(.hidden)
            }
            .padding()
            .naviagtiontitle("Revenue")
        }
    }
}


// object
struct RevinueStream: Identifiable {
    let id UUID()
    let name: String
    let value: Double
    let colour: Color
}

// struct with array of mock data.
// interestingly, The pie will not place the largest slice first, so we will need to sort the array to ensure the largest number is at index 0.
struct MockData {
    static var revinueSteams: [RevinueStream] = [
        .init(name: "Adsense", value: 806, colour: .teal),
        .init(name: "courses", value: 17855, colour: .pink),
        .init(name: "Sponsors", value: 4000, colour: .indigo),
        .init(name: "Consulting", value: 2500, colour: .blue)
    ]
}
```

1. this should not be hard coded with lets say(80.0) as it will not translate if the size of the pie is changed. I think this makes the dounut. will need to check in XCode.
2. Outer radius: 100 will make a donut chart. placing in a turnery (see example above) will let you pop out a particular slice.

