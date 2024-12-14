//
//  PushupSession.swift
//  TitanUp
//
//  Created by Huw Williams on 05/11/2024.
//

import Foundation

struct Session: Codable , Identifiable {
    var id = UUID()
    var date: Date
    var pushUps: Int
}


struct DailyTotal: Codable, Identifiable, Equatable {
    var id = UUID()
    var date: Date
    var dailyPushUps: Int
}


