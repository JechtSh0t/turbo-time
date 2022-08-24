//
//  Configuration.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import BSGAppBasics
import Foundation

///
/// A model for game configuration.
///
struct Configuration: Codable {
    
    var players: [String]
    var showTimer: Bool
    var minRoundTime: Int
    var maxRoundTime: Int
    var eventsPerRound: Int
}

extension Configuration {
    
    static var `default` = Configuration(players: ["Phil", "Matt", "Tom", "Tyler", "James"], showTimer: false, minRoundTime: 1.minutes, maxRoundTime: 5.minutes, eventsPerRound: 1)
    static var test = Configuration(players: ["Phil", "Matt", "Tom", "Tyler", "James"], showTimer: true, minRoundTime: 5, maxRoundTime: 10, eventsPerRound: 2)
    static var saved: Configuration { UserDefaults.standard.getObject(Configuration.self, forKey: "configuration") ?? .default }
}
