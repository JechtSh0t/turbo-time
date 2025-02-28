//
//  GameService.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

protocol GameServiceProtocol {
    var state: GameState { get }
    func start()
    func stop()
    func reset()
}

struct GameServiceMock: GameServiceProtocol {
    var state: GameState
    init(state: GameState) {
        self.state = state
    }
    func start() {}
    func stop() {}
    func reset() {}
}

///
/// A service for controlling the game.
///
@Observable
final class GameService: GameServiceProtocol {
    
    // MARK: - Properties -

    private var currentEvents: [Event]?
    private var gameTime: Int = 0
    private var roundRemainingTime: Int = 0
    private(set) var state: GameState = .idle
    private var timer: Timer?
    private var usedSingleBlueprints: Set<EventBlueprint> = []
    
    private var configuration: Configuration { configurationService.getConfiguration() }
    private var roundEventBlueprints: [EventBlueprint] {
        var roundEvents = [EventBlueprint]()
        for blueprint in configuration.blueprints {
            guard !usedSingleBlueprints.contains(blueprint) else { continue }
            switch blueprint.type {
            case .single(let frequency): roundEvents.append(contentsOf: Array(repeating: blueprint, count: frequency.rawValue))
            case .repeatable(let frequency): roundEvents.append(contentsOf: Array(repeating: blueprint, count: frequency.rawValue))
            case .timed: continue
            }
        }
        return roundEvents
    }
    private var timedEventBlueprints: [Int: EventBlueprint] {
        Dictionary(uniqueKeysWithValues: configuration.blueprints.compactMap {
            switch $0.type {
            case .timed(let time, let isEnabled) where isEnabled: (Int(time), $0)
            default: nil
            }
        })
    }
    
    // MARK: - Dependencies -
    
    private let configurationService: ConfigurationServiceProtocol
    
    // MARK: - Initializers -
    
    init(
        configurationService: ConfigurationServiceProtocol
    ) {
        self.configurationService = configurationService
    }
}

// MARK: - Timing -

extension GameService {
    
    ///
    /// Begin countdown to the next set of events.
    ///
    func start() {
        stop()
        roundRemainingTime = Int.random(in: configuration.minRoundTime...configuration.maxRoundTime)
        state = .countdown(roundRemainingTime)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: handleTimerIncrement)
    }
    
    ///
    /// Handle timer increments.
    /// - parameter timer: A reference to the timer.
    ///
    private func handleTimerIncrement(_ timer: Timer) {
        gameTime += 1
        roundRemainingTime -= 1
        state = .countdown(roundRemainingTime)
        if roundRemainingTime == 0 {
            stop()
            state = .events(generateRoundEvents())
        } else if let timedEventBlueprint = timedEventBlueprints[gameTime] {
            stop()
            state = .events([generateEvent(from: timedEventBlueprint)])
        }
    }
    
    ///
    /// Stop the game.
    ///
    func stop() {
        timer?.invalidate()
        roundRemainingTime = 0
        state = .idle
    }
    
    ///
    /// Called after events complete to reset to idle.
    ///
    func reset() {
        state = .idle
    }
}

// MARK: - Events -

extension GameService {
    
    ///
    /// Generate a set of events that will pop at the end of a round.
    /// - returns: A round of events.
    ///
    private func generateRoundEvents() -> [Event] {
        return (1...configuration.eventsPerRound).map { _ in
            let index = Int.random(in: 0..<roundEventBlueprints.count)
            let blueprint = roundEventBlueprints[index]
            let event = generateEvent(from: blueprint)
            if case .single = blueprint.type { usedSingleBlueprints.insert(blueprint) }
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
