//
//  MedalsAndTrophies.swift
//  TitanUp
//
//  Created by Huw Williams on 21/02/2025.
//

import Foundation

struct MedalsAndTrophies: Codable, Equatable  {
    // trohies
    var firstDay: Bool = false
    var seventhDay: Bool = false
    var thirtyDay: Bool = false
    var sixtyDay: Bool = false
    var ninetyDay: Bool = false
    var OneFiftyDay: Bool = false
    var twoHundredDay: Bool = false
    var threeHundredDay: Bool = false
    var threeSixtyFiveDay: Bool = false
    
    //medals
    var oneSession: Bool = false
    var twoSession: Bool = false
    var fiveSession: Bool = false
    var eightSession: Bool = false
    var tenSession: Bool = false
    var fifteenSession: Bool = false
    var twentySession: Bool = false
    var fiftySession: Bool = false
    
}
