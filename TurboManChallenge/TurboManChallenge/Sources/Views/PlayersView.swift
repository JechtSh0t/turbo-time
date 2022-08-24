//
//  PlayersView.swift
//
//  Created by JechtSh0t on 8/24/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

///
/// A list of players. Players can be added or removed.
///
struct PlayersView: View {
    
    // MARK: - Properties -
    
    @Binding var players: [String]
    @Binding var isVisible: Bool
    
    // MARK: - UI -
    
    var body: some View {
        
        AlertView(content: {
            EntryView(players: $players)
            List(players, id: \.self) { player in
                PlayerRow(name: player)
                    .swipeActions(edge: .trailing, content: {
                        Button(role: .destructive, action: {
                            guard let index = players.firstIndex(of: player) else { return }
                            withAnimation { _ = players.remove(at: index) }
                        }, label: {
                            Label("Remove", systemImage: "trash")
                        })
                    })
            }
            .listStyle(.plain)
            .frame(height: 160)
        }, buttonText: "Done", buttonAction: {
            withAnimation { isVisible = false }
        })
        
    }
}

struct EntryView: View {
    
    @Binding var players: [String]
    @State private var newPlayer: String = ""
    
    var body: some View {
        HStack {
            TextField("New player", text: $newPlayer)
                .foregroundColor(Color.alertText)
            Spacer()
            Button(action: {
                withAnimation { players.append(newPlayer) }
                newPlayer.removeAll()
            }, label: {
                Image(systemName: "plus")
            })
            .disabled(newPlayer.isEmpty)
        }
    }
}

struct PlayerRow: View {
    
    var name: String
    
    var body: some View {
        Text(name)
            .foregroundColor(Color.alertText)
            .listRowSeparator(.hidden)
    }
}

struct PlayersView_Previews: PreviewProvider {
    static var previews: some View {
        PlayersView(players: .constant(Configuration.default.players), isVisible: .constant(true)).preferredColorScheme(.light)
        PlayersView(players: .constant(Configuration.default.players), isVisible: .constant(true)).preferredColorScheme(.dark)
    }
}
