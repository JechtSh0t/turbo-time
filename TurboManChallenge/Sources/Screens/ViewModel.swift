//
//  ViewModel.swift
//
//  Created by JechtSh0t on 7/22/23.
//  Copyright © 2023 Brook Street Games. All rights reserved.
//

import Foundation
import SwiftData

// This causes warnings that take a bit to appear, but adding it to the view models
// individually causes issues with the screen state property. Not sure if this is an Xcode bug or not.
@MainActor
protocol ViewModel: Equatable, Hashable, Identifiable, Observable {
    var id: String { get }
}

// MARK: - Equatable -

extension ViewModel {

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Identifiable -

extension ViewModel {

    var id: String { UUID().uuidString }
}

// MARK: - Hashable -

extension ViewModel {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

