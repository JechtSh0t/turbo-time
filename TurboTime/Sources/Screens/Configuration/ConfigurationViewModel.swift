//
//  ConfigurationViewModel.swift
//
//  Created by JechtSh0t on 2/24/25.
//  Copyright © 2025 Brook Street Games. All rights reserved.
//

import BSGAppBasics
import SwiftUI

@Observable
final class ConfigurationViewModel: ViewModel {
   
    // MARK: - Nested Types -
    
    struct Constant {
        static let eventsKey = "events"
        static let eventsPerRoundKey = "eventsPerRound"
        static let maxRoundTimeKey = "maxRoundTime"
        static let minRoundTimeKey = "minRoundTime"
        static let playersKey = "players"
        static let showCountdownKey = "showCountdown"
        static let speakerKey = "speakerKey"
    }
    
    protocol ConfigurationProperty: Identifiable {
        var id: String { get }
        var title: String { get }
        var description: String { get }
    }
    
    struct IncrementConfigurationProperty: ConfigurationProperty {
        let id: String
        let title: String
        let description: String
        let increment: Int
        let minimum: Int
        let maximum: Int
        let currentValue: Int
        let display: (Int) -> String
    }
    
    struct InputConfigurationProperty: ConfigurationProperty {
        let id: String
        let title: String
        let description: String
        let display: String
    }
    
    struct ToggleConfigurationProperty: ConfigurationProperty {
        let id: String
        let title: String
        let description: String
        let currentOption: any (CaseWrappable & Displayable)
    }
    
    enum BooleanToggle: CaseWrappable, Displayable {
        case yes, no
        init(_ value: Bool) {
            switch value {
            case true: self = .yes
            case false: self = .no
            }
        }
        var display: String {
            switch self {
            case .yes: "YES"
            case .no: "NO"
            }
        }
        var value: Bool {
            switch self {
            case .yes: true
            case .no: false
            }
        }
    }
    
    // MARK: - Properties -
    
    var configuration: Configuration
    var configurationProperties: [any ConfigurationProperty] {[
        InputConfigurationProperty(
            id: Constant.eventsKey,
            title: "Events",
            description: "Tap to change event frequencies.",
            display: String(configuration.blueprints.filter({ $0.isEnabled }).count)
        ),
        InputConfigurationProperty(
            id: Constant.playersKey,
            title: "Players",
            description: "Tap to change players.",
            display: String(configuration.players.count)
        ),
        IncrementConfigurationProperty(
            id: Constant.eventsPerRoundKey,
            title: "Events / Round",
            description: "The number of events in each round.",
            increment: 1,
            minimum: 1,
            maximum: 10,
            currentValue: configuration.eventsPerRound,
            display: { String($0) }
        ),
        IncrementConfigurationProperty(
            id: Constant.minRoundTimeKey,
            title: "Min Round Time",
            description: "The minimum time between rounds.",
            increment: 30,
            minimum: 30,
            maximum: configuration.maxRoundTime,
            currentValue: configuration.minRoundTime,
            display: { $0.timeFormatted ?? "" }
        ),
        IncrementConfigurationProperty(
            id: Constant.maxRoundTimeKey,
            title: "Max Round Time",
            description: "The maximum time between rounds.",
            increment: 30,
            minimum: configuration.minRoundTime,
            maximum: 10.minutes,
            currentValue: configuration.maxRoundTime,
            display: { $0.timeFormatted ?? "" }
        ),
        ToggleConfigurationProperty(
            id: Constant.showCountdownKey,
            title: "Show Countdown",
            description: "Controls if the remaining round time is visible in game.",
            currentOption: BooleanToggle(configuration.showCountdown)
        ),
        ToggleConfigurationProperty(
            id: Constant.speakerKey,
            title: "Speaker Voice",
            description: "The voice of the speaker.",
            currentOption: configuration.voice
        )
    ]}
    let id = UUID()
    private var inputProperty: String?
    var screenState: ScreenState = .idle
    var shouldShowPlayers: Bool { inputProperty == Constant.playersKey }
    
    // MARK: - Dependencies -
    
    private let audioService: AudioServiceProtocol
    private let configurationService: ConfigurationServiceProtocol
    private weak var coordinator: RootCoordinator?
    
    // MARK: - Initializers -
    
    init(
        audioService: AudioServiceProtocol,
        configurationService: ConfigurationServiceProtocol,
        coordinator: RootCoordinator?
    ) {
        self.audioService = audioService
        self.configuration = configurationService.getConfiguration()
        self.configurationService = configurationService
        self.coordinator = coordinator
    }
}

// MARK: - View Actions -

extension ConfigurationViewModel {
    
    func screenAppeared() {
        configuration = configurationService.getConfiguration()
    }
    
    func incrementPropertyChanged(_ property: IncrementConfigurationProperty, to newValue: Int) {
        switch property.id {
        case Constant.eventsPerRoundKey: configuration.eventsPerRound = newValue
        case Constant.maxRoundTimeKey: configuration.maxRoundTime = newValue
        case Constant.minRoundTimeKey: configuration.minRoundTime = newValue
        default: break
        }
        configurationService.setConfiguration(configuration)
    }
    
    func inputPropertySelected(_ property: InputConfigurationProperty) {
        switch property.id {
        case Constant.eventsKey: coordinator?.eventConfigurationTriggered(from: self)
        case Constant.playersKey: inputProperty = property.id
        default: break
        }
    }
    
    func playerActionSelected(_ action: PlayersView.Action) {
        switch action {
        case .playerAdded(let player):
            configuration.players.append(player)
        case .playerRemoved(let player):
            guard let index = configuration.players.firstIndex(of: player) else { return }
            configuration.players.remove(at: index)
        case .doneButtonSelected:
            inputProperty = nil
        }
        configurationService.setConfiguration(configuration)
    }
    
    func inputPropertyDismissed() {
        inputProperty = nil
    }
    
    func togglePropertyChanged(_ property: ToggleConfigurationProperty) {
        switch property.id {
        case Constant.showCountdownKey:
            guard let nextOption = property.currentOption.next as? BooleanToggle else { break }
            configuration.showCountdown = nextOption.value
        case Constant.speakerKey:
            guard let nextOption = property.currentOption.next as? Voice, let voice = nextOption.speechVoice else { break }
            configuration.voice = nextOption
            audioService.speak(nextOption.display, voice: voice)
        default: break
        }
        configurationService.setConfiguration(configuration)
    }
    
    func defaultsButtonSelected() {
        configuration = .default
        configurationService.setConfiguration(configuration)
    }
}
