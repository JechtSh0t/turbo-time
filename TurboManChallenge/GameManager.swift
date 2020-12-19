//
//  GameManager.swift
//  JingleAllTheWay
//
//  Created by Phil on 12/9/20.
//

import Foundation

protocol GameManagerDelegate: class {
    
    func gameManager(_ gameManager: GameManager, didBeginRoundWithTime time: Int)
    func gameManager(_ gameManager: GameManager, didUpdateRemainingTime remainingTime: Int, roundOver: Bool)
}

class GameManager {
    
    // MARK: - Singleton -
    
    static let shared = GameManager()
    private init() {}
    
    // MARK: - Properties -
    
    private var timer: Timer!
    private var remainingTime: Int = 10
    private var remainingEventMessages: [String] = []
    weak var delegate: GameManagerDelegate?
    
    // MARK: - Game Configuration -
    
    private var players: [String] = ["Phil", "James", "Tom", "Matt", "Tyler"]
    private var events: [Event] = [
        
        Event(isRepeatable: true, involvedPlayers: 0, actionText: "The person in the lead gets caught trying to steal Ted’s present for Johnny nestled safely under the tree and loses one point"),
        Event(isRepeatable: true, involvedPlayers: 0, actionText: "Liz lets you drive her and Jamie too the parade after Howard destroys your house. The person in last place gets one point"),
        Event(isRepeatable: true, involvedPlayers: 0, actionText: "Shit a flat tire. The leader can not drink until the next round."),
        
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "You found the last Turbo Man at Toy Land. %@ gains one point"),
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "Dementor catches %@ and now he must take a shot of his choice in order to escape his lair."),
        
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "The toy store opens in two minutes, %@ must land a single flip cup on the first try in order to enter the store and receive one point"),
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "You’ve been caught driving around traffic on the way to your son’s karate class. Officer Hummel detains %@ and he cannot drink until the start of the next round"),
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "You ruined your son’s Christmas, take one heavy beer and you must finish before you finish your current beer or start your next. Here’s to you %@!"),
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "Oh no!! %@ has been caught by the Demon Team. Lose one point"),
        
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "Mr. Ponytail man says %@ can't sink this cup. Take a single shot for one point"),
        
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "Jingle bells batman smells. It's the mob against %@"),
        Event(isRepeatable: true, involvedPlayers: 1, actionText: "%@ found Ted on the roof. Take three shots to knock his ass off with a quarter."),
        
        Event(isRepeatable: true, involvedPlayers: 2, actionText: "They have one more Turbo Man at the radio station on Wabasha Street. %@ and %@ have a chug off to see who gets there first and gain one point"),
        Event(isRepeatable: false, involvedPlayers: 1, actionText: "%@ goes to try one of Liz’s cookies and burns his hand, now he must do the One Chip Challenge or lose three points as forfeit")
    ]
    
    // MARK: - Settings -
    
    let defaultShowTimer = false
    let defaultMinimumRoundTime = 5
    let defaultMaximumRoundTime = 10
    let defaultEventsPerRound = 1
    
    var shouldShowTimer: Bool {
        get { UserDefaults.standard.value(forKey: "shouldShowTimer") as? Bool ?? defaultShowTimer }
        set { UserDefaults.standard.setValue(newValue, forKey: "shouldShowTimer")}
    }
    
    var minimumRoundTime: Int {
        get { UserDefaults.standard.value(forKey: "minimumRoundTime") as? Int ?? defaultMinimumRoundTime }
        set { UserDefaults.standard.setValue(newValue, forKey: "minimumRoundTime")}
    }
    
    var maximumRoundTime: Int {
        get { UserDefaults.standard.value(forKey: "maximumRoundTime") as? Int ?? defaultMaximumRoundTime }
        set { UserDefaults.standard.setValue(newValue, forKey: "maximumRoundTime") }
    }
    
    var eventsPerRound: Int {
        get { UserDefaults.standard.value(forKey: "eventsPerRound") as? Int ?? defaultEventsPerRound }
        set { UserDefaults.standard.setValue(newValue, forKey: "eventsPerRound")}
    }
}

// MARK: - Formatting -

extension GameManager {
    
    func formatTime(seconds: Int) -> String? {
        
        let timeInterval = TimeInterval(seconds)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval) ?? ""
    }
}

// MARK: - Game Actions -

extension GameManager {
    
    func startRound() {
        
        let minutes = Int.random(in: minimumRoundTime...maximumRoundTime)
        remainingTime = minutes * 60
        var roundOver = false
        delegate?.gameManager(self, didBeginRoundWithTime: remainingTime)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            
            self.remainingTime -= 1
          
            if self.remainingTime == 0 {
                timer.invalidate()
                roundOver = true
            }
            
            self.delegate?.gameManager(self, didUpdateRemainingTime: self.remainingTime, roundOver: roundOver)
        })
    }
    
    func generateEvents() {
        
        for _ in 1...eventsPerRound {
            
            let eventIndex = Int.random(in: 0..<events.count)
            let event = events[eventIndex]
            var availablePlayers = players
            
            let eventMessage = String(format: "\(event.actionText)", selectPlayer(from: &availablePlayers), selectPlayer(from: &availablePlayers))
            if !event.isRepeatable { events.remove(at: eventIndex) }
            remainingEventMessages.append(eventMessage)
        }
    }
    
    func selectPlayer(from availablePlayers: inout [String]) -> String {
        
        let randomIndex = Int.random(in: 0..<availablePlayers.count)
        return availablePlayers.remove(at: randomIndex)
    }
    
    func nextEvent() -> String? {
        
        guard !remainingEventMessages.isEmpty else { return nil }
        return remainingEventMessages.removeFirst()
    }
}

// MARK: - Nested Types -

extension GameManager {
    
    struct Event {
        var isRepeatable: Bool
        var involvedPlayers: Int
        var actionText: String
    }
}
