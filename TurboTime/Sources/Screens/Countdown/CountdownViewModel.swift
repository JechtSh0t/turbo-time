//
//  CountdownViewModel.swift
//
//  Created by JechtSh0t on 2/24/25.
//  Copyright © 2025 Brook Street Games. All rights reserved.
//

import BSGAppBasics
import SwiftUI

@Observable
final class CountdownViewModel: ViewModel {
    
    // MARK: - Properties -
    
    let id = UUID()
    let screenState: ScreenState = .idle
    
    var countdownDisplay: String? {
        guard case .countdown(let time) = gameState, configurationService.getConfiguration().showCountdown else { return nil }
        return time.timeFormatted ?? ""
    }
    var gameState: GameState { gameService.state }
    
    // MARK: - Dependencies -
    
    private let audioService: AudioServiceProtocol
    private let configurationService: ConfigurationServiceProtocol
    private let gameService: GameServiceProtocol
    private weak var coordinator: RootCoordinator?
    
    // MARK: - Initializers -
    
    init(
        audioService: AudioServiceProtocol,
        configurationService: ConfigurationServiceProtocol,
        gameService: GameServiceProtocol,
        coordinator: RootCoordinator?
    ) {
        self.audioService = audioService
        self.configurationService = configurationService
        self.gameService = gameService
        self.coordinator = coordinator
    }
}

// MARK: - View Actions -

extension CountdownViewModel {
    
    func playButtonSelected() {
        gameService.start()
    }
    
    func stopButtonSelected() {
        gameService.stop()
    }
    
    func gameStateChanged(_ state: GameState) {
        switch state {
        case .events(let events): coordinator?.eventsTriggered(events, from: self)
        default: break
        }
    }
}
