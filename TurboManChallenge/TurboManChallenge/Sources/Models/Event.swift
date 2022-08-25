//
//  Event.swift
//
//  Created by JechtSh0t on 8/24/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

///
/// A single built event.
///
struct Event: Equatable {
    
    let blueprintText: String
    let players: [String]
    
    var text: String {
        switch players.count {
        case 0: return blueprintText
        case 1: return String(format: blueprintText, players[0])
        default: return String(format: blueprintText, players[0], players[1])
        }
    }
}
