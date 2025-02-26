//
//  RootCoordinator.swift
//
//  Created by JechtSh0t on 2/25/25.
//  Copyright © 2025 Brook Street Games. All rights reserved.
//

import BSGAppBasics
import SwiftData
import SwiftUI

///
/// The root coordinator for the app.
///
@Observable
final class RootCoordinator {

    // MARK: - Properties -

    var countdownViewModel: CountdownViewModel!
    var configurationViewModel: ConfigurationViewModel!
    var sheet: EventViewModel?
    
    // MARK: - Dependencies -

    private let audioService: AudioServiceProtocol
    private let configurationService: ConfigurationServiceProtocol
    private let gameService: GameServiceProtocol

    // MARK: - Initializers -

    init() {
        self.audioService = AudioService(voiceType: .americanChick)
        self.configurationService = ConfigurationService()
        self.gameService = GameService(
            eventBlueprints: EventBlueprint.all,
            configurationService: configurationService
        )
        self.countdownViewModel = CountdownViewModel(
            audioService: audioService,
            configurationService: configurationService,
            gameService: gameService,
            coordinator: self
        )
        self.configurationViewModel = ConfigurationViewModel(
            configurationService: configurationService
        )
    }
}

// MARK: - Coordination -

extension RootCoordinator {
    
    func eventsTriggered(_ events: [Event], from source: CountdownViewModel) {
        sheet = EventViewModel(
            events: events,
            audioService: audioService,
            coordinator: self
        )
    }
    
    func dismissSelected(from source: EventViewModel) {
        gameService.reset()
        sheet = nil
    }
}

// MARK: - UI -

struct RootCoordinatorView: View {

    @Bindable var coordinator: RootCoordinator

    var body: some View {
        TabView {
            CountdownView(viewModel: coordinator.countdownViewModel)
            .tabItem {
                Label("Game", systemImage: "dice.fill")
            }
            .background(Color.tabBar)
            ConfigurationView(viewModel: coordinator.configurationViewModel)
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .background(Color.tabBar)
        }
        .onAppear {
            // Setting the *standardAppearance* and *scrollEdgeAppearance* instances like navigation below
            // removes the unselected tint color. Selected item colors come from *AccentColor*.
            UITabBar.appearance().backgroundColor = UIColor(Color(.tabBar))
            let fadedItemColor = UIColor(Color(.tintColor)).withAlphaComponent(0.3)
            UITabBar.appearance().unselectedItemTintColor = fadedItemColor
        }
        .fullScreenCover(isPresented: Binding(get: { coordinator.sheet != nil }, set: { _ in coordinator.sheet = nil })) {
            if let viewModel = coordinator.sheet {
                EventView(viewModel: viewModel)
            }
        }
    }
}
