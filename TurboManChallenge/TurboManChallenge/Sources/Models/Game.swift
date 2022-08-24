//
//  Game.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

///
/// A model for the game.
///
final class Game: ObservableObject {

    // MARK: - Game Configuration -
    
    private let players: [String]
    private var eventPool: [Event]
    @Published var preferences: Preferences {
        didSet { UserDefaults.standard.setObject(preferences, forKey: "preferences") }
    }
    
    // MARK: - Properties -
    
    private var timer: Timer?
    @Published private(set) var countdownTime: Int = 0
    var countdownIsActive: Bool { timer?.isValid ?? false }
    
    private(set) var events = [String]()
    
    // MARK: - Initializers -
    
    init(players: [String], eventPool: [Event], preferences: Preferences = .default) {
        
        self.players = players
        self.eventPool = eventPool
        self.preferences = preferences
    }
}

// MARK: - Round Control -

extension Game {
    
    func startCountdown() {
        
        guard !countdownIsActive else { return }
        countdownTime = Int.random(in: preferences.minRoundTime...preferences.maxRoundTime)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            
            self.countdownTime -= 1
            
            if self.countdownTime == 0 {
                self.stopCountdown()
                self.events = self.generateEvents()
            }
        })
    }
    
    func stopCountdown() {
        
        timer?.invalidate()
        countdownTime = 0
        objectWillChange.send()
    }
}

// MARK: - Events -

extension Game {
    
    private func generateEvents() -> [String] {
        
        var events = [String]()
        
        for _ in 1...preferences.eventsPerRound {
            
            let eventIndex = Int.random(in: 0..<eventPool.count)
            let event = eventPool[eventIndex]
            var availablePlayers = players
            
            let eventMessage = String(format: "\(event.actionText)", selectPlayer(from: &availablePlayers), selectPlayer(from: &availablePlayers))
            if !event.isRepeatable { eventPool.remove(at: eventIndex) }
            events.append(eventMessage)
        }
        
        return events
    }
    
    private func selectPlayer(from availablePlayers: inout [String]) -> String {
        
        let randomIndex = Int.random(in: 0..<availablePlayers.count)
        return availablePlayers.remove(at: randomIndex)
    }
}
