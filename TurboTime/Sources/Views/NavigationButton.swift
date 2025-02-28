//
//  NavigationButton.swift
//
//  Created by JechtSh0t on 3/16/23.
//  Copyright © 2023 Brook Street Games. All rights reserved.
//

import SwiftUI

///
/// A button to use in the navigation toolbar.
///
struct NavigationButton: View {

    // MARK: - Type -

    enum `Type` {
        case add, back, delete, `import`, settings, share
    }

    // MARK: - Properties -

    let type: Type
    var image: Image {
        switch type {
        case .add: return Image(systemName: "plus")
        case .back: return Image(systemName: "chevron.left")
        case .delete: return Image(systemName: "trash")
        case .import: return Image(systemName: "square.and.arrow.down")
        case .settings: return Image(systemName: "gear")
        case .share: return Image(systemName: "square.and.arrow.up")
        }
    }
    let action: () -> Void

    // MARK: - UI -

    var body: some View {
        Button(action: {
            action()
        }, label: {
            image
                .foregroundColor(.text)
        })
    }
}

// MARK: - Preview -

#Preview {
    HStack(spacing: 24) {
        NavigationButton(type: .add, action: {})
        NavigationButton(type: .back, action: {})
        NavigationButton(type: .delete, action: {})
        NavigationButton(type: .import, action: {})
        NavigationButton(type: .settings, action: {})
        NavigationButton(type: .share, action: {})
    }
    .padding()
}
