//
//  EventBlueprint.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

///
/// A blueprint for an event.
///
struct EventBlueprint: Codable, Equatable, Hashable, Identifiable {
    
    // MARK: - Properties -
    
    let id: UUID
    let randomNumberRange: ClosedRange<Int>?
    let text: String
    let type: EventType
    
    // MARK: - Initializers -
    
    init(
        randomNumberRange: ClosedRange<Int>? = nil,
        text: String,
        type: EventType
    ) {
        self.id = UUID()
        self.randomNumberRange = randomNumberRange
        self.text = text
        self.type = type
    }
}

// MARK: - Packaged Blueprints -

extension EventBlueprint {
    
    static let `default`: [EventBlueprint] = [
        
        // Points
        
        EventBlueprint(
            text: "The leader gets caught stealing Ted’s present for Johnny. It was nestled safely under the tree. Lose one point.",
            type: .repeatable(.medium)
        ),
        EventBlueprint(
            text: "You found the last Turbo Man at Toy Land. [player] gains one point.",
            type: .repeatable(.medium)
        ),
        EventBlueprint(
            text: "Oh no!! [player] has been caught by the Demon Team. Lose one point.",
            type: .repeatable(.medium)
        ),
        EventBlueprint(
            text: "Liz lets you drive her and Jamie to the parade after Howard destroys your house. The person in last place gets one point.",
            type: .repeatable(.medium)
        ),
        
        // Slowdowns
        
        EventBlueprint(
            text: "Shit! A flat tire. The leader can not drink until the next round.",
            type: .repeatable(.medium)
        ),
        EventBlueprint(
            text: "You’ve been caught driving around traffic on the way to your son’s karate class. Officer Hummel detains [player] and he cannot drink until the start of the next round.",
            type: .repeatable(.medium)
        ),
        
        // Minigames
        
        EventBlueprint(
            text: "[player] vs [player] in one cup beer pong. Loser is Mr. Ponytail man and the winner gets one point.",
            type: .repeatable(.medium)
        ),
        EventBlueprint(
            text: "The toy store opens in two minutes. [player] and [player] battle in flip cup for the Turbo Man. Loser gets boosta.",
            type: .repeatable(.medium)
        ),
        EventBlueprint(
            text: "Ted is on the roof. First one of [player] and [player] to knock his ass off with a quarter gets a point.",
            type: .repeatable(.medium)
        ),
        EventBlueprint(
            text: "Strap in and guzzle up. It's turbo time! [player] vs [player] in a chug off.",
            type: .repeatable(.medium)
        ),
        EventBlueprint(
            text: "I'm gonna deck your halls bub. Slap off between [player] and [player]",
            type: .repeatable(.medium)
        ),
        EventBlueprint(
            randomNumberRange: 1...24,
            text: "Ted says you don't know shit [player]. Answer question number [number].",
            type: .repeatable(.medium)
        ),
        
        // Beer Swap
        
        EventBlueprint(
            text: "Restock at toy town! All players can take a beer from the fridge.",
            type: .repeatable(.medium)
        ),
        EventBlueprint(
            text: "He got two!! [player] can steal a beer from anybody or take from da fridge!",
            type: .repeatable(.medium)
        ),
        EventBlueprint(
            text: "A bomb? Swap one of your beers with someone else. Here’s to you [player]!",
            type: .repeatable(.medium)
        ),
        EventBlueprint(
            text: "You missed karate class again. [player] can take a beer of choice from the fridge.",
            type: .repeatable(.medium)
        ),
        EventBlueprint(
            text: "Ted is trying to pull a houdini on Liz. [player] can swap their stash with a player of their choice.",
            type: .repeatable(.medium)
        ),
        
        // Special
        
        EventBlueprint(
            text: "It's the Craft special. %@, %@, and %@ will do something cool!",
            type: .timed(TimeInterval(28.minutes), false)
        )
    ]
}
