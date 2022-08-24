//
//  PreferencesView.swift
//
//  Created by JechtSh0t on 8/24/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

///
/// A screen for adjusted game preferences.
///
struct PreferencesView: View {
    
    // MARK: - Configuration -
    
    private let roundIncrement = 30
    private let minRoundTime = 30
    private let maxRoundTime = 10.minutes
    private let minEvents = 1
    private let maxEvents = 5
    
    // MARK: - Properties -
    
    @Binding var preferences: Preferences
    
    // MARK: - UI -
    
    var body: some View {
        ZStack {
            Color.christmasRed
            VStack(spacing: 20) {
                ButtonRow(label: "Show Timer", value: preferences.showTimer ? "YES" : "NO") {
                    preferences.showTimer.toggle()
                }
                IncrementerRow(label: "Minimum Round Time", value: $preferences.minRoundTime, increment: roundIncrement, minimum: minRoundTime, maximum: min(preferences.maxRoundTime, maxRoundTime), display: { $0.timeFormatted ?? "" })
                IncrementerRow(label: "Maximum Round Time", value: $preferences.maxRoundTime, increment: roundIncrement, minimum: max(preferences.minRoundTime, minRoundTime), maximum: maxRoundTime, display: { $0.timeFormatted ?? "" })
                IncrementerRow(label: "Events / Round", value: $preferences.eventsPerRound, increment: 1, minimum: minEvents, maximum: maxEvents, display: { String($0) })
                Divider()
                    .frame(height: 1)
                    .background(Color.text)
                Button("Reset") {
                    preferences = Preferences.default
                }
                .font(.custom("Chalkduster", size: 18))
                .foregroundColor(.text)
            }
            .padding()
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

struct PreferencesView_Previews: PreviewProvider {
    
    static var previews: some View {
        PreferencesView(preferences: .constant(Preferences.default)).preferredColorScheme(.light)
        PreferencesView(preferences: .constant(Preferences.default)).preferredColorScheme(.dark)
    }
}
