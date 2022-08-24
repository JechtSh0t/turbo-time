//
//  ContentView.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

///
/// A container for all UI.
///
struct ContentView: View {
    
    // MARK: - Properties -
    
    @StateObject var game = Game(players: ["Phil", "Matt", "Tom", "Tyler", "James"], eventPool: Event.all, preferences: .saved)
    
    // MARK: - UI -
    
    var body: some View {
        
        TabView {
            CountdownView(game: game)
                .tabItem {
                    Image(systemName: "person.3.fill")
                }
                .background(Color.tabBar)
            
            PreferencesView(preferences: $game.preferences)
                .tabItem {
                    Image(systemName: "gear")
                }
                .background(Color.tabBar)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView().preferredColorScheme(.light)
        ContentView().preferredColorScheme(.dark)
    }
}
