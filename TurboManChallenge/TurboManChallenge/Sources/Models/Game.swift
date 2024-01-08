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
    
    private var eventBlueprints: [EventBlueprint]
    @Published var configuration: Configuration {
        didSet { UserDefaults.standard.setObject(configuration, forKey: "configuration") }
    }
    
    // MARK: - Properties -
    
    private var timer: Timer?
    @Published private(set) var countdownTime: Int = 0
    private var craftSpecialCountdownTime: Int = 28.minutes
    var countdownIsActive: Bool { timer?.isValid ?? false }
    
    private(set) var events = [Event]()
    
    // MARK: - Initializers -
    
    init(eventPool: [EventBlueprint], configuration: Configuration = .default) {
        
        self.eventBlueprints = eventPool
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
            self.craftSpecialCountdownTime -= 1
            
            if self.countdownTime == 0 {
                self.stopCountdown()
                self.events = self.generateEvents()
            } else if self.configuration.craftSpecial && self.craftSpecialCountdownTime == 0 {
                self.stopCountdown()
                self.events = self.generateCraftSpecialEvent()
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
    private func generateEvents() -> [Event] {
        
        (1...configuration.eventsPerRound).map { _ in
            let blueprintIndex = Int.random(in: 0..<eventBlueprints.count)
            let blueprint = eventBlueprints[blueprintIndex]
            var availablePlayers = configuration.players
            
            var selectedPlayers = [String]()
            if blueprint.playersRequired > 0 {
                for _ in 1...blueprint.playersRequired {
                    selectedPlayers.append(selectPlayer(from: &availablePlayers))
                }
            }
            
            let event = Event(blueprintText: blueprint.text, players: selectedPlayers)
            if !blueprint.isRepeatable { eventBlueprints.remove(at: blueprintIndex) }
            return event
        }
    }
    
    ///
    /// Generate a one-time Craft special event at the 28 minute mark.
    ///
    /// - returns: A sepcial event.
    ///
    private func generateCraftSpecialEvent() -> [Event] {
        
        let blueprint = EventBlueprint(isRepeatable: false, playersRequired: 3, text: "It's the Craft special. %@, %@, and %@ will do something cool!")
        var availablePlayers = configuration.players
        
        var selectedPlayers = [String]()
        if blueprint.playersRequired > 0 {
            for _ in 1...blueprint.playersRequired {
                selectedPlayers.append(selectPlayer(from: &availablePlayers))
            }
        }
        
        let event = Event(blueprintText: blueprint.text, players: selectedPlayers)
        return [event]
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
