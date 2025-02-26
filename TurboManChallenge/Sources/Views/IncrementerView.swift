//
//  IncrementerView.swift
//
//  Created by JechtSh0t on 8/24/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

///
/// A reusable incrementer view.
///
struct IncrementerView: View {

    // MARK: - Properties -

    @Binding private(set) var value: Int
    var increment = 1
    let minimum: Int
    let maximum: Int
    let font: (name: String, size: CGFloat)
    var display: (Int) -> String = { String($0) }

    private var incrementIsAvailable: Bool { value <= maximum - increment }
    private var decrementIsAvailable: Bool { value >= minimum + increment }

    // MARK: - UI -

    var body: some View {
        let buttonDimension = font.size
        HStack(alignment: .center, spacing: -buttonDimension / 8) {
            IncrementerButton(image: Image(systemName: "minus"), padding: buttonDimension / 4) {
                changeValue(value - increment)
            }
            .frame(width: buttonDimension, height: buttonDimension)
            .disabled(!decrementIsAvailable)
            .opacity(decrementIsAvailable ? 1 : 0)

            Text(display(value))
                .font(.custom(font.name, size: font.size))
                .fixedSize()

            IncrementerButton(image: Image(systemName: "plus"), padding: buttonDimension / 4) {
                changeValue(value + increment)
            }
            .frame(width: buttonDimension, height: buttonDimension)
            .disabled(!incrementIsAvailable)
            .opacity(incrementIsAvailable ? 1 : 0)
        }
    }
}

// MARK: - Subviews -

extension IncrementerView {

    struct IncrementerButton: View {

        let image: Image
        let padding: CGFloat
        let action: () -> Void

        var body: some View {
            Button(action: {
                action()
            }, label: {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: .infinity)
                    .padding(padding)
                    .contentShape(Rectangle())
            })
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Adjustment -

extension IncrementerView {

    ///
    /// Change the current value if constraints are satisfied.
    /// - parameter newValue: The new value.
    ///
    func changeValue(_ newValue: Int) {
        value = newValue
    }
}

// MARK: - Preview -

#Preview {
    @Previewable @State var count = 1
    VStack(alignment: .leading, spacing: 20) {
        IncrementerView(value: $count, minimum: 0, maximum: 20, font: (name: "SF Pro", size: 32))
        IncrementerView(value: $count, minimum: 0, maximum: 20, font: (name: "SF Pro", size: 48))
        IncrementerView(value: $count, minimum: 0, maximum: 20, font: (name: "SF Pro", size: 64))
    }
}

