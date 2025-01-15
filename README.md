<p align= "center">
<img src="/docs/assets/TitanUp.jpg"/>
</p>

## Description of the Application
<p align= "justify">
TitanUp is a pushup app that monitors reps using the front camera of your iPhone. This ensures that collected data is correct. The app is designed to give the user a no-bs metric to track push-up improvementant and upper body strength training. TitanUp also focuses on building a masculine mindset and a can-do attitude to life. This app will bring out the warrior in you. If mental health is a key part of your daily routine, TitanUp is a must-have for comfort, motivation, and mindset-conditioning.
</p>
Click [here](/docs/designDiary.md) for an in-depth look into the objectives of TitanUP.

# Table of Contents

* [Key Features](#key-features)
* [Front Camera - QuickPose Pacakge](/docs/FrontCameraPoseDetection.md)
* [Design Diary](/docs/designDiary.md)

## Key Features

* Push-up detection using Machine Learning packages and the front camera. No more cheating.
* A masculine, warrior-like space for you to live in your inner Titan.
* Motivational quotes and verses to prepare you for the challenges ahead.
* Voice packs for different levels to emulate respect.
* Award-bsed progerss system.

## Understanding the User Interface

The Home Page consists of a Tabview, the home page, and profile view. This is all executed from the content page. This allows the user to flip between profile and home by tapping on the corresponding icon in the footer. To access the front camera, the user presses the center footer button.

### Login Screen

The login screen holds a textfield and a securefield for user input with a button for execution. It is very recognisable as a login page.

The view uses a view model object to access logic and data structures. A simple conditional checks to see whether there is an error message present and if so, it pronts it above the main title.

Next, the main title sits above the text field which accepts the user's email. This is bound to the email variable in the view model.

The next field is secure and accepts the user's password. this is also bound to the view model. The button executes the login method in the view model.

Both fields where refactored to they could be used again by other pages. The refactored code can he found [here.](/docs/refactoredCode.md)

__Currently, the login view does not return to the content view (TabView) once the user logs in. Working on it.__

```swift
import SwiftUI

struct LoginView: View {
    // access to view model.
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        // custom container that has a VStack and an Image.
        BackgroundImage {
              // aligns the 2 fields and button vertically.
            VStack(spacing: 20) {
                // displays error message.
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
                // Title
                Text("Welcome Back!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                // Email
                CustomTextField(placeholder: "email", text: $viewModel.email)
                
                
                // Password
                CustomSecureField(placeholder: "Password", text: $viewModel.password)
                
                // Login Button
                Button(action: {
                    viewModel.login()
                    
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.titanUpBlue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 10)
                
            }
            .padding()
            .frame(maxWidth: 400) // Limit width of container.
        }
    }
}
```

## LoginViewModel

The Login ViewModel accepts the data from the view (name, email, password) and uses it to authenticate. Once a taken has been create within Firebase, the user should not need to log in again.

```swift
//
//  LoginViewModel.swift
//  TitanUp
//
//  Created by Huw Williams on 05/11/2024.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = "";
    @Published var password = "";
    @Published var errorMessage = "";
    
    
    func login() {
        guard validate() else {
            return;
        }
        Auth.auth().signIn(withEmail: email, password: password);
    }
    
    // this checks that a passweord as been empty and an actual email is entered.
    private func validate() -> Bool{
        
        self.errorMessage = ""
        
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "please enter login details.";
            return false;
        }
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "please enter a valid email."
            return false;
        }
        return true;
    }
}



```

## TabView (ContentView)

The content view is the default file available when a XCode project is made. It was decided that it would be the TabView page where the app would check whether the user is login or not.

If the user is not logged in, the login view will be displayed, otherwise the TabView will execute and display the HomeView with in the tab view. This will be embedded with a footer showing the Home, Profile, and Medal icons. When the user clicks on an icon, the corresponding view will display.

```swift
struct ContentView: View {
    @StateObject var contentViewModel = ContentViewModel()
    var body: some View {
        
            if contentViewModel.isSignedIn, !contentViewModel.currentUserId.isEmpty {
                HomeTabView(uid: "P83CGGUVLnUFB6v9uZ4XDhM2DeD2")        
            } else {
                //StartView()
                HomeTabView(uid: "P83CGGUVLnUFB6v9uZ4XDhM2DeD2")
                    
            }
    }
}

struct HomeTabView: View {
    @State var uid: String
    var body: some View {
        
        ZStack {
            TabView {
                HomeView(userId: uid)
                    .tabItem { Label("home", systemImage: "clock") }
                
                // MedalPage
                
                ProfileView()
                    .tabItem { Label("prifile", systemImage: "person") }
            }
            .background(Color.titanUpMidBlue)
            VStack {
                Spacer()
                NavigationLink(destination: PoseNetDetection()){
                    ZStack{
                        Circle()
                            .frame(width: 80)
                            .foregroundStyle(Color.titanUpBlue)
                        Circle()
                            .frame(width: 70)
                    }
                }
            }
        }
    }
}
```

### Home Screen
The home view is embedded into the tab view and is used to visualise the user's data via bar and pie charts. To achieve this, databse snapshots are filtered and stored as arrays.

Firstly, the view model retrieves a snapshot. This is done immediately upon view model init.

```swift
// HomeViewModel
func fetchSessions() {
        // checks to see if unique id is present.
        guard !user.isEmpty else {
            print("User ID is empty.")
            return
        }
        // gets snapshot of user data
        db.collection("TitanUpUsers").document(user).collection("DailySessions").getDocuments { snapshot, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching sessions: \(error.localizedDescription)")
                    return
                }
                // inserts data into session object and appends to array
                self.sessions = snapshot?.documents.compactMap { document -> Session? in
                    let data = document.data()
                    let sessionId = document.documentID
                    let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                    let pushUps = data["pushUps"] as? Int ?? 0
                    return Session(sessionId: sessionId, date: date, pushUps: pushUps)
                } ?? []
                
                // Update filtered sessions after fetching
                self.filterSessionsForToday()
                self.filterSessionsFor7Days()
                self.filterSessionsFor3Months()
                
                print("Retrieved sessions: \(self.sessions)")
            }
        }
    }

```
Once the data has been retrieved, it is placed into the `Session` object - which is constructed from this data structure.

```swift
// Model (PushupSession)
struct Session: Codable, Identifiable, Equatable {

    var sessionId: String // Maps to Firestore's document ID
    var date: Date
    var pushUps: Int
    var isAnimated: Bool = false
    // Computed property for Identifiable
    var id: String { sessionId }
    
}

```

it is then placed in an array of `Session` located within the same class. It is named `sessions`. the `fetchSessions` function is executed within the init as mentioned ealier.

```swift
// HomeViewModel
// this is only to top of the class, sans functions.
class HomeViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var todaySessions: [Session] = []
    @Published var weekSessions: [Session] = []
    @Published var monthSessions: [Session] = []
    @Published var user: String = Auth.auth().currentUser?.uid ?? ""
    
    private var db = Firestore.firestore()
    
    init() {
        fetchSessions()
    }
}

```

These session arrays are used by the Charts to visualise data. Get more info on the [Charts](#charts).

## Profile Panel

This displays a generic image of a viking and will soon display consistency rewards. 

#### The medals on the home view are still under development.

### Profile Screen

The profile screen is under construction.

### Charts
* [Pie Chart](/docs/pieChart.md)
* [Bar Chart](/docs/barChart.md)

The charts are members of the SwiftUI charts package an are utilised as a data display feature. The three charts represent the user's daily (pie), weekly (bar), and monthly(bar) contributions to their push-up journey.  

### Trophy Screen

Under development

### Front Camera Pose Detection Screen

The push-up detection feature is currently utilising the [QuickPose](/docs/FrontCameraPoseDetection.md), which is a paid feature. TitanUp is utilising the freemium version for prototyping with the hope of creating its own pose detection feature.

## Software

