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
    
    // MARK: - Properties -
    
    let blueprint: EventBlueprint
    let randomNumber: Int?
    let players: [String]
    
    var text: String {
        var text = blueprint.text
        var players = players
        while let range = text.range(of: "[player]") {
            guard !players.isEmpty else { break }
            text = text.replacingCharacters(in: range, with: players.removeFirst())
        }
        if let randomNumber = randomNumber {
            text = text.replacingOccurrences(of: "[number]", with: String(randomNumber))
        }
        return text
    }
    
    // MARK: - Initializers -
    
    init(
        blueprint: EventBlueprint,
        availablePlayers: [String]
    ) {
        self.blueprint = blueprint
        if let range = blueprint.randomNumberRange {
            self.randomNumber = Int.random(in: range)
        } else {
            self.randomNumber = nil
        }
        let playerCount = blueprint.text.components(separatedBy: "[player]").count - 1
        self.players = Array(availablePlayers.shuffled().prefix(playerCount))
    }
}
