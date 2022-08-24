//
//  ConfigurationView.swift
//
//  Created by JechtSh0t on 8/24/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

///
/// A screen for adjusted game configuration.
///
struct ConfigurationView: View {
    
    // MARK: - Configuration -
    
    private let roundIncrement = 30
    private let minRoundTime = 30
    private let maxRoundTime = 10.minutes
    private let minEvents = 1
    private let maxEvents = 5
    
    // MARK: - Properties -
    
    @Binding var configuration: Configuration
    @State var showPlayersView = false
    
    // MARK: - UI -
    
    var body: some View {
        ZStack {
            Color.christmasRed
            if showPlayersView {
                PlayersView(players: $configuration.players, isVisible: $showPlayersView)
                        .transition(.scale)
            } else {
                VStack(spacing: 20) {
                    ButtonRow(label: "Players", value: String(configuration.players.count)) {
                        withAnimation { showPlayersView = true }
                    }
                    ButtonRow(label: "Show Timer", value: configuration.showTimer ? "YES" : "NO") {
                        configuration.showTimer.toggle()
                    }
                    IncrementerRow(label: "Minimum Round Time", value: $configuration.minRoundTime, increment: roundIncrement, minimum: minRoundTime, maximum: min(configuration.maxRoundTime, maxRoundTime), display: { $0.timeFormatted ?? "" })
                    IncrementerRow(label: "Maximum Round Time", value: $configuration.maxRoundTime, increment: roundIncrement, minimum: max(configuration.minRoundTime, minRoundTime), maximum: maxRoundTime, display: { $0.timeFormatted ?? "" })
                    IncrementerRow(label: "Events / Round", value: $configuration.eventsPerRound, increment: 1, minimum: minEvents, maximum: maxEvents, display: { String($0) })
                    Divider()
                        .frame(height: 1)
                        .background(Color.text)
                    Button("Reset") {
                        configuration = Configuration.default
                    }
                    .font(.custom("Chalkduster", size: 18))
                    .foregroundColor(.text)
                }
                .padding()
            }
        }
    }
}

struct ButtonRow: View {
    
    let label: String
    let value: String
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Text(label)
                .font(.custom("Chalkduster", size: 14))
                .foregroundColor(.text)
            Spacer()
            Button(value) {
                action()
            }
            .font(.custom("Chalkduster", size: 18))
            .foregroundColor(.text)
        }
    }
}

struct IncrementerRow: View {

    let label: String
    @Binding var value: Int
    let increment: Int
    let minimum: Int
    let maximum: Int
    let display: (Int) -> String
    
    var body: some View {
        
        HStack {
            Text(label)
                .font(.custom("Chalkduster", size: 14))
                .foregroundColor(.text)
            Spacer()
            IncrementerView(value: $value, increment: increment, minimum: minimum, maximum: maximum, color: .text, fontSize: 24, customFontName: "Chalkduster", display: display)
        }
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    
    static var previews: some View {
        ConfigurationView(configuration: .constant(Configuration.default)).preferredColorScheme(.light)
        ConfigurationView(configuration: .constant(Configuration.default)).preferredColorScheme(.dark)
    }
}
