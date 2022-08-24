//
//  Preferences.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import BSGAppBasics
import Foundation

///
/// A model for user preferences.
///
struct Preferences: Codable {
    
    var showTimer: Bool
    var minRoundTime: Int
    var maxRoundTime: Int
    var eventsPerRound: Int
}

extension Preferences {
    
    static var `default` = Preferences(showTimer: false, minRoundTime: 1.minutes, maxRoundTime: 5.minutes, eventsPerRound: 1)
    static var test = Preferences(showTimer: true, minRoundTime: 5, maxRoundTime: 10, eventsPerRound: 2)
    static var saved: Preferences { UserDefaults.standard.getObject(Preferences.self, forKey: "preferences") ?? .default }
}
