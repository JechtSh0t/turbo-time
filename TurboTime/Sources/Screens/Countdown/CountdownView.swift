//
//  CountdownView.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI
import BSGAppBasics

///
/// A screen for awaiting the next event.
///
struct CountdownView: View {
    
    // MARK: - Properties -
    
    let viewModel: CountdownViewModel
    
    // MARK: - UI -
    
    var body: some View {
        VStack {
            switch viewModel.gameState {
            case .idle:
                playButton
            case .countdown:
                Text("Waiting for Event")
                    .font(.custom("Lexend", size: 28))
                if let timeDisplay = viewModel.countdownDisplay {
                    Text(timeDisplay)
                        .font(.custom("Lexend", size: 64))
                }
                stopButton
            case .events:
                EmptyView()
            }
        }
        .padding(24)
        .screenBackground()
        .foregroundColor(.text)
        .onChange(of: viewModel.gameState) { _, state in
            viewModel.gameStateChanged(state)
        }
    }
}

// MARK: - Action Button -

extension CountdownView {
    
    private var playButton: some View {
        Button(action: {
            viewModel.playButtonSelected()
        }, label: {
            Image(systemName: "play.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
        })
    }
    
    private var stopButton: some View {
        Button(action: {
            viewModel.stopButtonSelected()
        }, label: {
            Image(systemName: "stop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        })
    }
}

// MARK: - Previews -

#Preview("Idle") {
    let viewModel = CountdownViewModel(
        audioService: AudioServiceMock(),
        configurationService: ConfigurationServiceMock(),
        gameService: GameServiceMock(state: .idle),
        coordinator: nil
    )
    CountdownView(viewModel: viewModel)
}

#Preview("Countdown") {
    var configuration = Configuration.default
    configuration.showCountdown = true
    let viewModel = CountdownViewModel(
        audioService: AudioServiceMock(),
        configurationService: ConfigurationServiceMock(configuration: configuration),
        gameService: GameServiceMock(state: .countdown(30)),
        coordinator: nil
    )
    return CountdownView(viewModel: viewModel)
}
