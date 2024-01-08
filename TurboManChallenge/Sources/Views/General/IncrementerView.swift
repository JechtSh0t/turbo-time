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
    
    // MARK: - Configuration -
    
    private let fadedButtonAlpha = CGFloat(0.3)
    
    // MARK: - Properties -
    
    @Binding private(set) var value: Int
    var increment = 1
    let minimum: Int
    let maximum: Int
    var color: Color = .black
    var fontSize: CGFloat = 16
    var customFontName: String?
    var display: (Int) -> String = { value in String(value) }
    
    private var incrementAvailable: Bool { value > maximum - increment }
    private var decrementAvailable: Bool { value < minimum + increment }
    
    // MARK: - UI -
    
    var body: some View {
        
        let buttonDimension = fontSize
        HStack(spacing: buttonDimension / 2) {
            
            IncrementerButton(image: Image(systemName: "minus"), color: color, padding: buttonDimension / 4) {
                changeValue(value - increment)
            }
            .frame(width: buttonDimension, height: buttonDimension)
            .disabled(decrementAvailable)
            .opacity(decrementAvailable ? fadedButtonAlpha : 1.0)
            
            Text(display(value))
                .font(customFontName == nil ? .system(size: fontSize) : .custom(customFontName!, size: fontSize))
                .foregroundColor(color)
           
            IncrementerButton(image: Image(systemName: "plus"), color: color, padding: buttonDimension / 4) {
                changeValue(value + increment)
            }
            .frame(width: buttonDimension, height: buttonDimension)
            .disabled(incrementAvailable)
            .opacity(incrementAvailable ? fadedButtonAlpha : 1.0)
        }
    }
    
    ///
    /// Change the current value if constraints are satisfied.
    ///
    /// - parameter newValue: The new value.
    ///
    func changeValue(_ newValue: Int) {
        
        guard (minimum...maximum).contains(newValue) else { return }
        value = newValue
    }
}

struct IncrementerButton: View {
    
    let image: Image
    let color: Color
    let padding: CGFloat
    let action: () -> Void
    
    var body: some View {
        
        Button(action: {
            action()
        }, label: {
            image
                .resizable()
                .scaledToFit()
                .foregroundColor(color)
                .padding(padding)
        })
    }
}

struct IncrementerView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            IncrementerView(value: .constant(1), minimum: 1, maximum: 5, fontSize: 36)
            IncrementerView(value: .constant(1), minimum: 1, maximum: 5, fontSize: 48)
            IncrementerView(value: .constant(1), minimum: 1, maximum: 5, fontSize: 64)
        }
    }
}
