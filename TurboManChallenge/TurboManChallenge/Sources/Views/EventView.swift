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
    
    private let speaker = Speaker(voiceType: .americanGirl)
    @State private var currentEvent: String?
    @State var events: [String]
    @Binding var isVisible: Bool
    
    // MARK: - UI -
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Text(currentEvent == nil ? "Turbo Time!" : "New Event!")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.alertText)
            
            if let currentEvent = currentEvent {
                Text(currentEvent)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.alertText)
            }
            
            Divider()
            
            Button(action: {
                guard !events.isEmpty else {
                    speaker.stop()
                    withAnimation { isVisible = false }
                    return
                }
                currentEvent = events.removeFirst()
                speaker.speak(currentEvent!)
                
            }, label: {
                Text(currentEvent == nil ? "Start Events" : "Continue")
                    .font(.title3)
                    .fontWeight(.black)
                    .foregroundColor(.christmasRed)
            })
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color.alert)
        .shadow(radius: 10, x: 5, y: 5)
        .cornerRadius(10)
        .transition(.scale)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.alertText, lineWidth: 5)
        )
    }
    
    private func announceEvent() {
        
        guard let event = events.first else { return }
        speaker.speak(event)
    }
}

struct EventView_Previews: PreviewProvider {
    
    static var previews: some View {
        EventView(events: [], isVisible: .constant(true)).preferredColorScheme(.light)
        EventView(events: [], isVisible: .constant(true)).preferredColorScheme(.dark)
    }
}
