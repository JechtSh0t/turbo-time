//
//  Coordinator.swift
//
//  Created by JechtSh0t on 2/15/23.
//  Copyright © 2023 Brook Street Games. All rights reserved.
//

import SwiftUI

@MainActor
protocol Coordinator: Equatable, Hashable, ObservableObject {

    /// A unique identifier.
    var id: String { get }
    /// A parent coordinator if there is one.
    var parent: (any Coordinator)? { get }
    /// The main path used by the navigation stack.
    var path: NavigationPath { get set }
    /// A screen that pops over everything else. Handled by the root coordinator.
    var popover: (any ViewModel)? { get set }
    /// All currently presented screens. Excludes popovers for now.
    var record: [any ViewModel] { get set }
    /// A modal screen that slides up from the bottom.
    var sheet: (any ViewModel)? { get set }

    func presentPath(_ viewModel: any ViewModel)
    func presentPopover(_ viewModel: any ViewModel)

    /// Dismiss the top screen.
    func dismiss()
    /// Can be implemented by coordinators to perform tasks before a screen is dismissed.
    /// Right now this is manually called when view models disappear.
    func dismissSelected(from source: any ViewModel)
}

// MARK: - Coordination -

extension Coordinator {

    func presentPath(_ viewModel: any ViewModel) {
        path.append(viewModel)
        record.append(viewModel)
    }

    func presentPopover(_ viewModel: any ViewModel) {
        if let parent = parent {
            parent.presentPopover(viewModel)
        } else {
            popover = viewModel
        }
    }

    func presentSheet(_ viewModel: any ViewModel) {
        sheet = viewModel
        record.append(viewModel)
    }

    func dismiss() {
        if popover != nil {
            popover = nil
        } else if sheet != nil {
            sheet = nil
            _ = record.popLast()
        } else if !path.isEmpty {
            path.removeLast()
            _ = record.popLast()
        }
    }

    func dismissSelected(from source: any ViewModel) {}
}

// MARK: - Equatable -

extension Coordinator {

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Identifiable -

extension Coordinator {

    var id: String { UUID().uuidString }
}

// MARK: - Hashable -

extension Coordinator {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

