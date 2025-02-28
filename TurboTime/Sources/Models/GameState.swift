//
//  GameState.swift
//
//  Created by JechtSh0t on 2/25/25.
//  Copyright © 2025 Brook Street Games. All rights reserved.
//

///
/// All available game states.
///
enum GameState: Equatable {
    case idle
    case countdown(Int)
    case events([Event])
}
