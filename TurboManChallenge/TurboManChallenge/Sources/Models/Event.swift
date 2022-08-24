//
//  Event.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

///
/// A blueprint for an event.
///
struct Event {
    var isRepeatable: Bool
    var involvedPlayers: Int
    var actionText: String
}

extension Event {
    
    static var all: [Event] = [
        
        Event(isRepeatable: true, involvedPlayers: 0, actionText: "The leader gets caught stealing Ted’s present for Johnny. It is no longer nestled safely under the tree. Lose one point."),
        Event(isRepeatable: true, involvedPlayers: 0, actionText: "Liz lets you drive her and Jamie to the parade after Howard destroys your house. The person in last place gets one point."),
        Event(isRepeatable: true, involvedPlayers: 0, actionText: "Shit a flat tire. The leader can not drink until the next round."),
        
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "You found the last Turbo Man at Toy Land. %@ gains one point."),
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "Dementor catches %@ and now he must take a shot of his choice in order to escape his lair."),
        
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "The toy store opens in two minutes. %@ must land a single flip cup on the first try in order to enter the store and receive one point."),
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "You’ve been caught driving around traffic on the way to your son’s karate class. Officer Hummel detains %@ and he cannot drink until the start of the next round."),
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "You ruined your son’s Christmas, take one heavy beer and finish it before drinking anything else. Here’s to you %@!"),
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "Oh no!! %@ has been caught by the Demon Team. Lose one point."),
        
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "Mr. Ponytail man says %@ can't sink this cup. Take a single shot for one point."),
        
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "Jingle bells batman smells. It's the mob against %@."),
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "%@ found Ted on the roof. Take three shots to knock his ass off with a quarter."),
        
        Event(isRepeatable: true, involvedPlayers: 2, actionText: "They have one more Turbo Man at the radio station on Wabasha Street. %@ and %@ have a chug off to see who gets there first. The winner gets one point."),
        
        Event(isRepeatable: false, involvedPlayers: 1, actionText: "%@ goes to try one of Liz’s cookies and burns their hand. Accept the One Chip Challenge or lose three points as forfeit.")
    ]
}
