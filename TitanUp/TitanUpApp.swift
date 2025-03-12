//
//  TitanUpApp.swift
//  TitanUp
//
//  Created by Huw Williams on 12/08/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabaseInternal

@main
struct TitanUpApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate;
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            //OSFrontCameraView() // tesing a more robust counter
               ContentView()
            }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let centre = UNUserNotificationCenter.current();
        centre.delegate = self;
        return true;
    }
    
    // add Notification app delegate.
}
