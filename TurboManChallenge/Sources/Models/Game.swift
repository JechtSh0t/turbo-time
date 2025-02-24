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
@Observable
final class Game {

    // MARK: - Properties -
    
    private(set) var activeEvents = [Event]()
    var configuration: Configuration {
        didSet { UserDefaults.standard.setObject(configuration, forKey: "configuration") }
    }
    var countdownIsActive: Bool { timer?.isValid ?? false }
    private var gameTime: Int = 0
    private var roundEvents: [EventBlueprint]
    private(set) var roundRemainingTime: Int = 0
    private let timedEvents: [Int: EventBlueprint]
    private var timer: Timer?
    
    // MARK: - Initializers -
    
    init(eventBlueprints: [EventBlueprint], configuration: Configuration = .default) {
        self.configuration = configuration
        var roundEvents = [EventBlueprint]()
        for blueprint in eventBlueprints {
            switch blueprint.type {
            case .single: roundEvents.append(blueprint)
            case .repeatable(let frequency): roundEvents.append(contentsOf: Array(repeating: blueprint, count: frequency.rawValue))
            case .timed: continue
            }
        }
        self.roundEvents = roundEvents
        timedEvents = Dictionary(uniqueKeysWithValues: eventBlueprints.compactMap {
            switch $0.type {
            case .single, .repeatable: nil
            case .timed(let time): (Int(time), $0)
            }
        })
    }
}

// MARK: - Timing -

extension Game {
    
    ///
    /// Begin countdown to the next set of events.
    ///
    func startCountdown() {
        guard !countdownIsActive else { return }
        roundRemainingTime = Int.random(in: configuration.minRoundTime...configuration.maxRoundTime)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: handleTimerIncrement)
    }
    
    ///
    /// Handle timer increments.
    /// - parameter timer: A reference to the timer.
    ///
    private func handleTimerIncrement(_ timer: Timer) {
        gameTime += 1
        roundRemainingTime -= 1
        if roundRemainingTime == 0 {
            stopCountdown()
            activeEvents = generateRoundEvents()
        } else if let timedEventBlueprint = timedEvents[gameTime] {
            stopCountdown()
            activeEvents = [generateEvent(from: timedEventBlueprint)]
        }
    }
    
    ///
    /// Stop the game.
    ///
    func stopCountdown() {
        timer?.invalidate()
        roundRemainingTime = 0
    }
}

// MARK: - Events -

extension Game {
    
    ///
    /// Generate a set of events that will pop at the end of a round.
    /// - returns: A round of events.
    ///
    private func generateRoundEvents() -> [Event] {
        (1...configuration.eventsPerRound).map { _ in
            let index = Int.random(in: 0..<roundEvents.count)
            let blueprint = roundEvents[index]
            let event = generateEvent(from: blueprint)
            if blueprint.type == .single { roundEvents.remove(at: index) }
            return event
        }
    }
    
    ///
    /// Generate a single of event from a blueprint.
    /// - parameter blueprint: The blueprint to create the event from.
    /// - returns: A single event.
    ///
    private func generateEvent(from blueprint: EventBlueprint) -> Event {
        return Event(
            blueprint: blueprint,
            availablePlayers: configuration.players
        )
    }
}
