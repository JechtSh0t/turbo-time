//
//  EventView.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

///
/// A popover for displaying and announcing events.
///
struct EventView: View {
    
    // MARK: - Properties -

    @State var currentEvent: Event?
    @State var events: [Event]
    @Binding var isVisible: Bool
    var speaker = Speaker(voiceType: .americanChick)
    
    // MARK: - UI -
    
    var body: some View {
        
        AlertView(title: currentEvent == nil ? "Turbo Time!" : "New Event!", content: {
            
            if let currentEvent = currentEvent {
                buildDisplayText(for: currentEvent)
                    .font(.callout)
                    .multilineTextAlignment(.center)
            } else {
                Image("Howard")
            }
            
        }, buttonText: currentEvent == nil ? "Start Events" : "Continue", buttonAction: {
            if let event = events.first {
                currentEvent = events.removeFirst()
                speaker.speak(event.text)
            } else {
                speaker.stop()
                withAnimation { isVisible = false }
            }
        })
    }
}

// MARK: - Event Text -

extension EventView {
    
    ///
    /// Builds display text highlighting player names in bold red.
    ///
    /// - parameter event: The event to build text for.
    /// - returns: Display text.
    ///
    private func buildDisplayText(for event: Event) -> Text {
        
        var players = event.players
        var components = event.blueprintText.components(separatedBy: "%@")
        guard components.count == players.count + 1 else { return Text("") }
        
        var text = Text(components.removeFirst())
        
        while !players.isEmpty && !components.isEmpty {
            text = text + Text(players.removeFirst()).foregroundColor(.accentColor).font(.custom("Chalkduster", size: 16)).fontWeight(.heavy)
            text = text + Text(components.removeFirst()).foregroundColor(.alertText)
        }
        return text
    }
}

struct EventView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let blueprint = EventBlueprint.all.max { $0.text.count < $1.text.count }!
        let event = Event(blueprintText: blueprint.text, players: Array(repeating: "Player", count: blueprint.playersRequired))
        
        VStack(spacing: 20) {
            EventView(events: [], isVisible: .constant(true))
            EventView(currentEvent: event, events: [event], isVisible: .constant(true))
        }
        .preferredColorScheme(.light)
        
        VStack(spacing: 20) {
            EventView(events: [], isVisible: .constant(true))
            EventView(currentEvent: event, events: [event], isVisible: .constant(true))
        }
        .preferredColorScheme(.dark)
    }
}
