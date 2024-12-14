//
//  MockData.swift
//  TitanUp
//
//  Created by Huw Williams on 20/11/2024.
//

import Foundation


struct MockData {
    
    var count = 0 // put this back into function
    static var DailySession: [Session] = [
        .init(date: Date.now, pushUps: 10),
        .init(date: Date.now, pushUps: 8),
        .init(date: Date.now, pushUps: 7),
        .init(date: Date.now, pushUps: 8)
    ]
    var WeeklySessions: [Int] = []
    
    mutating func totalPushUps() -> Int {
        
        for session in MockData.DailySession {
            count += session.pushUps
        }
        return count
    }
    
    mutating func MakeWeeklyTotals() {
        
        for _ in 0...5 {
            let total = totalPushUps()
            WeeklySessions.append(total)
            
        }
    }
    init() {
        self.MakeWeeklyTotals()
    }
}



