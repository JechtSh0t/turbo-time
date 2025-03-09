//
//  EventViewModel.swift
//
//  Created by JechtSh0t on 2/25/25.
//  Copyright © 2025 Brook Street Games. All rights reserved.
//

import BSGAppBasics
import SwiftUI

@Observable
final class EventViewModel: ViewModel {
    
    // MARK: - Properties -

    private var currentEvent: Event?
    private var eventNumber: Int = 0
    let id = UUID()
    private var remainingEvents: [Event]
    let screenState: ScreenState = .idle
    
    var titleText: String { currentEvent == nil ? "Turbo Time!" : "Event #\(eventNumber)" }
    var eventText: Text {
        guard let event = currentEvent else {
            return Text("Press start to begin the events!").foregroundColor(.text)
        }
        return buildDisplayText(for: event)
    }
    var buttonText: String { currentEvent == nil ? "Start" : "Next" }
    
    // MARK: - Dependencies -
    
    private let audioService: AudioServiceProtocol
    private let configurationService: ConfigurationServiceProtocol
    private weak var coordinator: RootCoordinator?
    
    // MARK: - Initializers -
    
    init(
        events: [Event],
        audioService: AudioServiceProtocol,
        configurationService: ConfigurationServiceProtocol,
        coordinator: RootCoordinator?
    ) {
        self.remainingEvents = events
        self.audioService = audioService
        self.configurationService = configurationService
        self.coordinator = coordinator
    }
}

// MARK: - View Actions -

extension EventViewModel {
    
    func screenAppeared() {
        audioService.play("TurboTime")
    }
    
    func buttonSelected() {
        cycleEvents()
    }
}

// MARK: - Events -

extension EventViewModel {
    
    ///
    /// Builds display text highlighting player names in bold red.
    ///
    /// - parameter event: The event to build text for.
    /// - returns: Display text.
    ///
    private func buildDisplayText(for event: Event) -> Text {
        let components = event.text.components(separatedBy: ["[", "]"])
        var result = Text("")
        for (index, component) in components.enumerated() {
            if index.isMultiple(of: 2) {
                result = result + Text(component).foregroundStyle(Color.text)
            } else {
                result = result + Text(component).foregroundStyle(Color.accentColor).bold()
            }
        }
        return result
    }
    
    ///
    /// Display the next event, or dismiss if on the last one.
    ///
    private func cycleEvents() {
        audioService.stop()
        if let event = remainingEvents.first {
            currentEvent = event
            remainingEvents.removeFirst()
            eventNumber += 1
            if let voice = configurationService.getConfiguration().voice.speechVoice {
                audioService.speak(event.text, voice: voice)
            }
        } else {
            coordinator?.dismissSelected(from: self)
        }
    }
}
