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
    
    private var eventPool: [Event]
    @Published var configuration: Configuration {
        didSet { UserDefaults.standard.setObject(configuration, forKey: "configuration") }
    }
    
    // MARK: - Properties -
    
    private var timer: Timer?
    @Published private(set) var countdownTime: Int = 0
    var countdownIsActive: Bool { timer?.isValid ?? false }
    
    private(set) var events = [String]()
    
    // MARK: - Initializers -
    
    init(eventPool: [Event], configuration: Configuration = .default) {
        
        self.eventPool = eventPool
        self.configuration = configuration
    }
}

// MARK: - Round Control -

extension Game {
    
    ///
    /// Begin countdown to the next set of events.
    ///
    func startCountdown() {
        
        guard !countdownIsActive else { return }
        countdownTime = Int.random(in: configuration.minRoundTime...configuration.maxRoundTime)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            
            self.countdownTime -= 1
            
            if self.countdownTime == 0 {
                self.stopCountdown()
                self.events = self.generateEvents()
            }
        })
    }
    
    ///
    /// Stop the current countdown.
    ///
    func stopCountdown() {
        
        timer?.invalidate()
        countdownTime = 0
        objectWillChange.send()
    }
}

// MARK: - Events -

extension Game {
    
    ///
    /// Generate a set of events that will occur when the countdown completes.
    ///
    /// - returns: One round worth of generated events.
    ///
    private func generateEvents() -> [String] {
        
        var events = [String]()
        
        for _ in 1...configuration.eventsPerRound {
            
            let eventIndex = Int.random(in: 0..<eventPool.count)
            let event = eventPool[eventIndex]
            var availablePlayers = configuration.players
            
            let eventMessage = String(format: "\(event.actionText)", selectPlayer(from: &availablePlayers), selectPlayer(from: &availablePlayers))
            if !event.isRepeatable { eventPool.remove(at: eventIndex) }
            events.append(eventMessage)
        }
        
        return events
    }
    
    ///
    /// Select a player for an event. Ensures the same player cannot be selected twice.
    ///
    /// - parameter availablePlayers: The players who have not yet been selected.
    /// - returns: A newly selected player.
    ///
    private func selectPlayer(from availablePlayers: inout [String]) -> String {
        
        let randomIndex = Int.random(in: 0..<availablePlayers.count)
        return availablePlayers.remove(at: randomIndex)
    }
}
