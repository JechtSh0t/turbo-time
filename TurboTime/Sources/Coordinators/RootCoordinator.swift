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
final class RootCoordinator: Coordinator {
    
    // MARK: - Properties -

    var countdownViewModel: CountdownViewModel!
    var configurationViewModel: ConfigurationViewModel!
    let id = UUID()
    weak var parent: (any Coordinator)?
    var path = NavigationPath()
    var popover: (any ViewModel)?
    var record = [any ViewModel]()
    var sheet: (any ViewModel)?
    
    // MARK: - Dependencies -

    private let audioService: AudioServiceProtocol
    private let configurationService: ConfigurationServiceProtocol
    private let gameService: GameServiceProtocol

    // MARK: - Initializers -

    init() {
        self.audioService = AudioService()
        self.configurationService = ConfigurationService()
        self.gameService = GameService(
            configurationService: configurationService
        )
        self.countdownViewModel = CountdownViewModel(
            audioService: audioService,
            configurationService: configurationService,
            gameService: gameService,
            coordinator: self
        )
        self.configurationViewModel = ConfigurationViewModel(
            audioService: audioService,
            configurationService: configurationService,
            coordinator: self
        )
    }
}

// MARK: - Coordination -

extension RootCoordinator {
    
    func eventsTriggered(_ events: [Event], from source: CountdownViewModel) {
        sheet = EventViewModel(
            events: events,
            audioService: audioService,
            configurationService: configurationService,
            coordinator: self
        )
    }
    
    func eventConfigurationTriggered(from source: ConfigurationViewModel) {
        path.append(EventConfigurationViewModel(
            configurationService: configurationService,
            coordinator: self
        ))
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
            NavigationStack(path: $coordinator.path) {
                ConfigurationView(viewModel: coordinator.configurationViewModel)
                    .navigationDestination(for: EventConfigurationViewModel.self) {
                        EventConfigurationView(viewModel: $0)
                    }
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .tint(.tabBarIcon)
        .onAppear {
            // Setting the *standardAppearance* and *scrollEdgeAppearance* instances like navigation below
            // removes the unselected tint color.
            UITabBar.appearance().backgroundColor = UIColor(Color(.tabBarBackground))
            let fadedItemColor = UIColor(Color(.tabBarIcon)).withAlphaComponent(0.3)
            UITabBar.appearance().unselectedItemTintColor = fadedItemColor
            
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color(.text))]
            navigationBarAppearance.backgroundColor = UIColor(Color(.mainBackground))
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        .fullScreenCover(isPresented: Binding(get: { coordinator.sheet != nil }, set: { _ in coordinator.sheet = nil })) {
            if let viewModel = coordinator.sheet as? EventViewModel {
                EventView(viewModel: viewModel)
            }
        }
    }
}
