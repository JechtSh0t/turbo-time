//
//  EventConfigurationViewModel.swift
//
//  Created by JechtSh0t on 2/27/25.
//  Copyright © 2025 Brook Street Games. All rights reserved.
//

import SwiftUI

@Observable
final class EventConfigurationViewModel: ViewModel {
    
    // MARK: - Properties -
    
    private var configuration: Configuration
    
    var sections: [(title: String, events: [EventBlueprint])] {[
        ("Repeatable Events", repeatableEvents),
        ("Single Events", singleEvents),
        ("Timed Events", timedEvents)
    ]}
    var repeatableEvents: [EventBlueprint] {
        configuration.blueprints.filter {
            if case .repeatable = $0.type { return true }
            else { return false }
        }
    }
    var singleEvents: [EventBlueprint] {
        configuration.blueprints.filter {
            if case .single = $0.type { return true }
            else { return false }
        }
    }
    var timedEvents: [EventBlueprint] {
        configuration.blueprints.filter {
            if case .timed = $0.type { return true }
            else { return false }
        }
    }
    
    // MARK: - Dependencies -
    
    private let configurationService: ConfigurationServiceProtocol
    private weak var coordinator: RootCoordinator?
    
    // MARK: - Initializers -
    
    init(
        configurationService: ConfigurationServiceProtocol,
        coordinator: RootCoordinator?
    ) {
        self.configuration = configurationService.getConfiguration()
        self.configurationService = configurationService
        self.coordinator = coordinator
    }
}

// MARK: - View Actions -

extension EventConfigurationViewModel {
    
    func frequencyToggled(for blueprint: EventBlueprint) {
        guard let index = configuration.blueprints.firstIndex(of: blueprint) else { return }
        switch blueprint.type {
        case .single(let frequency): configuration.blueprints[index] = changeType(of: blueprint, to: .single(frequency.next))
        case .repeatable(let frequency): configuration.blueprints[index] = changeType(of: blueprint, to: .repeatable(frequency.next))
        case .timed(let time, let isEnabled): configuration.blueprints[index] = changeType(of: blueprint, to: .timed(time, !isEnabled))
        }
        configurationService.setConfiguration(configuration)
    }
    
    func backButtonSelected() {
        coordinator?.dismiss()
    }
}

// MARK: - Adjustment -

extension EventConfigurationViewModel {
    
    private func changeType(of blueprint: EventBlueprint, to type: EventType) -> EventBlueprint {
        EventBlueprint(
            randomNumberRange: blueprint.randomNumberRange,
            text: blueprint.text,
            type: type
        )
    }
}

// MARK: - Display -

extension EventConfigurationViewModel {
    
    func valueDisplay(for blueprint: EventBlueprint) -> String {
        switch blueprint.type {
        case .single(let frequency): return frequency.display
        case .repeatable(let frequency): return frequency.display
        case .timed(let time, let isEnabled):
            if isEnabled, let timeDisplay = Int(time).timeFormatted {
                return "On (\(timeDisplay))"
            } else {
                return "Off"
            }
        }
    }
}
