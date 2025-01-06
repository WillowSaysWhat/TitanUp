//
//  PushupSession.swift
//  TitanUp
//
//  Created by Huw Williams on 05/11/2024.
//

import Foundation


struct Session: Codable, Identifiable {
    var sessionId: String // Maps to Firestore's document ID
    var date: Date
    var pushUps: Int
    
    // Computed property for Identifiable
    var id: String { sessionId }
    
}







