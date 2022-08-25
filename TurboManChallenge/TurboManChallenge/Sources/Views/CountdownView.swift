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
    
    @ObservedObject var game: Game
    @State var soundPlayer = AudioGenerator()
    @State var eventIsActive = false
    
    // MARK: - UI -
    
    var body: some View {
        
        ZStack {
            Color.christmasRed
            VStack {
                if eventIsActive {
                    EventView(events: game.events, isVisible: $eventIsActive)
                            .transition(.scale)
                } else {
                    if game.countdownIsActive {
                        Text("Waiting for Event")
                            .font(.custom("Chalkduster", size: 30.0))
                            .foregroundColor(.text)
                    }
                    if game.configuration.showTimer && game.countdownIsActive {
                        Text(game.countdownTime.timeFormatted ?? "")
                            .font(.custom("Chalkduster", size: 60.0))
                            .foregroundColor(.text)
                    }
                    ActionButton(game: game)
                        .frame(width: 100, height: 100)
                }
            }
            .padding(.horizontal)
            .onChange(of: game.events, perform: { _ in
                if !game.events.isEmpty {
                    soundPlayer.playSound("turbo-time")
                    withAnimation { eventIsActive = true }
                }
            })
        }
    }
}

struct ActionButton: View {
    
    @ObservedObject var game: Game
    
    var body: some View {
        Button(action: {
            game.countdownIsActive ? game.stopCountdown() : game.startCountdown()
        }, label: {
            Image(systemName: game.countdownIsActive ? "stop.circle.fill" : "play.circle.fill")
                .resizable()
                .scaledToFit()
        })
        .foregroundColor(.text)
    }
}

struct CountdownView_Previews: PreviewProvider {
    
    static var previews: some View {
        CountdownView(game: Game(eventPool: EventBlueprint.all)).preferredColorScheme(.light)
        CountdownView(game: Game(eventPool: EventBlueprint.all)).preferredColorScheme(.dark)
    }
}
