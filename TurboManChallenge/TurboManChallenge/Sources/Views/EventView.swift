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
    
    // MARK: - Constants -
    
    private let speaker = Speaker(voiceType: .americanGirl)
    
    // MARK: - Properties -

    @State var currentEvent: String?
    @State var events: [String]
    @Binding var isVisible: Bool
    
    // MARK: - UI -
    
    var body: some View {
        
        AlertView(title: currentEvent == nil ? "Turbo Time!" : "New Event!", content: {
            
            if let currentEvent = currentEvent {
                Text(currentEvent)
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.alertText)
            }
            
        }, buttonText: currentEvent == nil ? "Start Events" : "Continue", buttonAction: {
            guard !events.isEmpty else {
                speaker.stop()
                withAnimation { isVisible = false }
                return
            }
            currentEvent = events.removeFirst()
            speaker.speak(currentEvent!)
        })
    }
    
    ///
    /// Read the event using a speaker.
    ///
    private func announceEvent() {
        
        guard let event = events.first else { return }
        speaker.speak(event)
    }
}

struct EventView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let longestEventText = Event.all.map { $0.actionText }.max { $0.count < $1.count }!
        
        VStack {
            EventView(events: [], isVisible: .constant(true))
            EventView(currentEvent: longestEventText, events: [longestEventText], isVisible: .constant(true))
        }
        .preferredColorScheme(.light)
        
        VStack {
            EventView(events: [], isVisible: .constant(true))
            EventView(currentEvent: longestEventText, events: [longestEventText], isVisible: .constant(true))
        }
        .preferredColorScheme(.dark)
    }
}
