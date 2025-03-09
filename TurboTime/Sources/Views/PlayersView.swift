//
//  PlayersView.swift
//
//  Created by JechtSh0t on 8/24/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

///
/// A view to add or remove players.
///
struct PlayersView: View {
    
    enum Action {
        case doneButtonSelected
        case playerAdded(String)
        case playerRemoved(String)
    }
    
    // MARK: - Properties -
    
    let players: [String]
    let actionHandler: (Action) -> Void
    
    @State private var newPlayer: String = ""
    
    // MARK: - UI -
    
    var body: some View {
        AlertView(
            content: {
                entryView
                playerListView
            },
            buttonAction: {
                actionHandler(.doneButtonSelected)
            }
        )
        .foregroundStyle(Color.text)
        .frame(height: 300)
    }
}

// MARK: - Entry -

extension PlayersView {
    
    private var entryView: some View {
        HStack {
            TextField(
                "New Player",
                text: $newPlayer,
                prompt: Text("New Player").foregroundColor(.text.opacity(0.5))
            )
            .tint(.text)
            Spacer()
            Button(action: {
                actionHandler(.playerAdded(newPlayer))
                newPlayer.removeAll()
            }, label: {
                Image(systemName: "plus.app.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            })
            .disabled(newPlayer.isEmpty)
            .opacity(newPlayer.isEmpty ? 0 : 1)
        }
        .font(.custom("Lexend", size: 16))
    }
}

// MARK: - Players -

extension PlayersView {
    
    private var playerListView: some View {
        List(players, id: \.self) { player in
            PlayerRow(name: player)
                .swipeActions(edge: .trailing, content: {
                    Button(role: .destructive, action: {
                        guard let index = players.firstIndex(of: player) else { return }
                        actionHandler(.playerRemoved(players[index]))
                    }, label: {
                        Label("Remove", systemImage: "trash")
                    })
                    .tint(.black)
                })
        }
        .listStyle(.plain)
    }
    
    struct PlayerRow: View {
        
        var name: String
        
        var body: some View {
            Text(name)
                .font(.custom("Lexend", size: 16))
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.mainBackground)
        }
    }
}

// MARK: - Previews -

#Preview {
    PlayersView(
        players: Configuration.default.players,
        actionHandler: { _ in }
    )
}
