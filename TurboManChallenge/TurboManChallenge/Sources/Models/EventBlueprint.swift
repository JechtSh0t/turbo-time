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
struct EventBlueprint {
    var isRepeatable: Bool
    var playersRequired: Int
    var text: String
}

extension EventBlueprint {
    
    static var all: [EventBlueprint] = [
        
        EventBlueprint(isRepeatable: true, playersRequired: 0, text: "The leader gets caught stealing Ted’s present for Johnny. It is no longer nestled safely under the tree. Lose one point."),
        EventBlueprint(isRepeatable: true, playersRequired: 0, text: "Liz lets you drive her and Jamie to the parade after Howard destroys your house. The person in last place gets one point."),
        EventBlueprint(isRepeatable: true, playersRequired: 0, text: "Shit! A flat tire. The leader can not drink until the next round."),
        
        EventBlueprint(isRepeatable: true, playersRequired: 1, text: "You found the last Turbo Man at Toy Land. %@ gains one point."),
        EventBlueprint(isRepeatable: true, playersRequired: 1, text: "Dementor catches %@ and now he must take a shot of his choice in order to escape his lair."),
        
        EventBlueprint(isRepeatable: true, playersRequired: 1, text: "The toy store opens in two minutes. %@ must land a single flip cup on the first try in order to enter the store and receive one point."),
        EventBlueprint(isRepeatable: true, playersRequired: 1, text: "You’ve been caught driving around traffic on the way to your son’s karate class. Officer Hummel detains %@ and he cannot drink until the start of the next round."),
        EventBlueprint(isRepeatable: true, playersRequired: 1, text: "You ruined your son’s Christmas, take one heavy beer and finish it before drinking anything else. Here’s to you %@!"),
        EventBlueprint(isRepeatable: true, playersRequired: 1, text: "Oh no!! %@ has been caught by the Demon Team. Lose one point."),
        
        EventBlueprint(isRepeatable: true, playersRequired: 1, text: "Mr. Ponytail man says %@ can't sink this cup. Take a single shot for one point."),
        
        EventBlueprint(isRepeatable: true, playersRequired: 1, text: "Jingle bells batman smells. It's the mob against %@."),
        EventBlueprint(isRepeatable: true, playersRequired: 1, text: "%@ found Ted on the roof. Take three shots to knock his ass off with a quarter."),
        
        EventBlueprint(isRepeatable: true, playersRequired: 2, text: "They have one more Turbo Man at the radio station on Wabasha Street. %@ and %@ have a chug off to see who gets there first. The winner gets one point."),
        
        EventBlueprint(isRepeatable: false, playersRequired: 1, text: "%@ goes to try one of Liz’s cookies and burns their hand. Accept the One Chip Challenge or lose three points as forfeit.")
    ]
}
