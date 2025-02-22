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
struct EventBlueprint: Equatable {
    
    // MARK: - Properties -
    
    let isRepeatable: Bool
    let randomNumberRange: ClosedRange<Int>?
    let text: String
    
    // MARK: - Initializers -
    
    init(
        isRepeatable: Bool = true,
        randomNumberRange: ClosedRange<Int>? = nil,
        text: String
    ) {
        self.isRepeatable = isRepeatable
        self.randomNumberRange = randomNumberRange
        self.text = text
    }
}

// MARK: - Packaged Blueprints -

extension EventBlueprint {
    
    static var all: [EventBlueprint] = [
        
        // Points
        
        EventBlueprint(
            isRepeatable: true,
            text: "The leader gets caught stealing Ted’s present for Johnny. It was nestled safely under the tree. Lose one point."
        ),
        EventBlueprint(
            isRepeatable: true,
            text: "You found the last Turbo Man at Toy Land. [player] gains one point."
        ),
        EventBlueprint(
            isRepeatable: true,
            text: "Oh no!! [player] has been caught by the Demon Team. Lose one point."
        ),
        EventBlueprint(
            isRepeatable: true,
            text: "Liz lets you drive her and Jamie to the parade after Howard destroys your house. The person in last place gets one point."
        ),
        
        // Slowdowns
        
        EventBlueprint(
            isRepeatable: true,
            text: "Shit! A flat tire. The leader can not drink until the next round."
        ),
        EventBlueprint(
            isRepeatable: true,
            text: "You’ve been caught driving around traffic on the way to your son’s karate class. Officer Hummel detains [player] and he cannot drink until the start of the next round."
        ),
        
        // Minigames
        
        EventBlueprint(
            isRepeatable: true,
            text: "[player] vs [player] in one cup beer pong. Loser is Mr. Ponytail man and the winner gets one point."
        ),
        EventBlueprint(
            isRepeatable: true,
            text: "The toy store opens in two minutes. [player] and [player] battle in flip cup for the Turbo Man. Loser gets boosta."
        ),
        EventBlueprint(
            isRepeatable: true,
            text: "Ted is on the roof. First one of [player] and [player] to knock his ass off with a quarter gets a point."
        ),
        EventBlueprint(
            isRepeatable: true,
            text: "Strap in and guzzle up. It's turbo time! [player] vs [player] in a chug off."
        ),
        EventBlueprint(
            isRepeatable: true,
            text: "I'm gonna deck your halls bub. Slap off between [player] and [player]"
        ),
        EventBlueprint(
            isRepeatable: true,
            randomNumberRange: 1...24,
            text: "Ted says you don't know shit [player]. Answer question number [number]."
        ),
        
        // Beer Swap
        
        EventBlueprint(
            isRepeatable: true,
            text: "Restock at toy town! All players can take a beer from the fridge."
        ),
        EventBlueprint(
            isRepeatable: true,
            text: "He got two!! [player] can steal a beer from anybody or take from da fridge!"
        ),
        EventBlueprint(
            isRepeatable: true,
            text: "A bomb? Swap one of your beers with someone else. Here’s to you [player]!"
        ),
        EventBlueprint(
            isRepeatable: true,
            text: "You missed karate class again. [player] can take a beer of choice from the fridge."
        ),
        EventBlueprint(
            isRepeatable: true,
            text: "Ted is trying to pull a houdini on Liz. [player] can swap their stash with a player of their choice."
        )
    ]
}
