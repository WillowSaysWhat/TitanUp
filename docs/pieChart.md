<p align="center">
<img src="/docs/assets/pieChartHeading.jpg"/>
</p>

This is the SwiftUI pie chart that will be used in TitanUp. This comes from the YT tutorial SwiftUI Pie and Dounut charts - New to iOS 17 - https://www.youtube.com/watch?v=8M3N4HWUc0U
First accessed 31 October 2024.

## Objects needed

This is just here as another example of tamplating data and preparing it for the DB. for TitanUp implementation click [here](#titanup-implementation).

```swift
// this is an example of converting the original bar chart data into other data
struct ConvertedChartData: Identifiable, Equatable {
    let id = UUID()
    var value: Double
    var date: Date
}

// this is the object template
struct StackedBarChartData: Identifiable, Equatable {
    let id = UUID()
    var value: Double
    var date: Date
    var type: String
}

```

The two example above are very simple structs that can be used to input data into the pie chart
Below the view struct are two. One is an object blueprint and the other is a struct with a list of mockdata to help visualise the pie chart.

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

Take a look at the [Bar Chart](/docs/barChart.md) code.



# TitanUp Implementation

The pie chart on the home view uses the `viewModel.dailySessions` array to build it's segments.

```swift
// this chart sits in a ZStack and is placed on top of a rounded rectangle.

// if the arry is empty display text.
if viewModel.todaySessions.isEmpty {
                    Text("No Sessions")
                } else {
                    // otherwise enumerate over array and build pie
                    Chart(viewModel.todaySessions) { session in
                        
                            SectorMark(angle: .value("reps", session.pushUps), innerRadius: .ratio(0.3), angularInset: 1.2)
                                .cornerRadius(5)
                        
                    }
                    .opacity(pieTrigger)
                    .onAppear() {
                        // slowly fade the pie chart in.
                        withAnimation(.linear(duration: 1.5)){
                            pieTrigger = 1
                        }
                    }
                    
                    
                }

```
<p align="center">
<img src="/docs/assets/chartsOnHome.png" width=200/>
</p>

A simple animation fades the pie in after the view is initialised. This will eventually be upgraded to a building animation whenever session data is updated.

The Pie will also become clickable so that more detailed information can be provided to the user. Howeve, this is out of scope for the current iteration of TitanUp.