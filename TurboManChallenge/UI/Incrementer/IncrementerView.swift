//
//  IncrementerView.swift
//  incrementer-view
//
//  Created by Phil on 7/22/20.
//  Copyright © 2020 Brook Street Games. All rights reserved.
//

import UIKit

// MARK: - Delegate -

protocol IncrementerViewDelegate: class {
    
    /// Called when the value is about to be updated, to the delegate a chance to reject the new value.
    func incrementerView(_ view: IncrementerView, shouldUpdateValueTo newValue: Int, oldValue: Int) -> Bool
    /// Called immediately before the value is updated.
    func incrementerView(_ view: IncrementerView, willUpdateValueTo newValue: Int, oldValue: Int)
    /// Called immediately after the value is updated.
    func incrementerView(_ view: IncrementerView, didUpdateValueTo newValue: Int, oldValue: Int)
}

extension IncrementerViewDelegate {
    
    func incrementerView(_ view: IncrementerView, shouldUpdateValueTo newValue: Int, oldValue: Int) -> Bool { true }
    func incrementerView(_ view: IncrementerView, willUpdateValueTo newValue: Int, oldValue: Int) {}
    func incrementerView(_ view: IncrementerView, didUpdateValueTo newValue: Int, oldValue: Int) {}
}

// MARK: - Class -

///
/// Contains a text field with two buttons. The buttons can be used to alter the value in the field, or the user can tap the field to bring up a custom digit-only keyboard.
///
class IncrementerView: UIView {
    
    // MARK: - Public Properties -
    
    /// If false, no adjustments can be made and the UI will be faded.
    var isEnabled: Bool = true {
        didSet { updateUI(for: currentValue) }
    }
    
    /// The value displayed in the text field.
    private(set) var currentValue: Int!
    /// Object that handles changes from within incrementerView.
    weak var delegate: IncrementerViewDelegate?
    
    // MARK: - Configuration -
    
    private var maxValue: Int!
    private var minValue: Int!
    private let fadedButtonAlpha: CGFloat = 0.3
    private let fadedTextAlpha: CGFloat = 0.5
    
    // MARK: - UI -
    
    @IBOutlet private weak var decrementButton: UIButton!
    @IBOutlet private weak var decrementImageView: UIImageView!
    
    @IBOutlet private weak var valueTextField: UITextField!
    
    @IBOutlet private weak var incrementButton: UIButton!
    @IBOutlet private weak var incrementImageView: UIImageView!
    
    private var digitKeyboardView: DigitKeyboardView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Configuration -

extension IncrementerView {
    
    ///
    /// Sets up a new *IncrementerView* with default styling.
    /// - note: If custom styling is desired, *setStyle*, and *setKeyboardStyle* can be used.
    ///
    /// - parameter startingValue: The value that will start out in the text field.
    /// - parameter maxValue: The maximum value the incrementer will allow in the text field.
    /// - parameter minValue: The minimum value the incrementer will allow in the text field.
    ///
    func configure(startingValue: Int, maxValue: Int, minValue: Int) {
        
        currentValue = startingValue
        self.maxValue = maxValue
        self.minValue = minValue
        
        valueTextField.text = String(startingValue)
        valueTextField.delegate = self
        
        let digitKeyboardView = DigitKeyboardView.create()
        digitKeyboardView.delegate = self
        self.digitKeyboardView = digitKeyboardView
        valueTextField.inputView = digitKeyboardView
        
        valueTextField.inputAssistantItem.leadingBarButtonGroups = []
        valueTextField.inputAssistantItem.trailingBarButtonGroups = []
        
        setStyle(fieldColor: .clear, fontName: "Arial", textColor: .black, buttonColor: .black)
        updateUI(for: startingValue)
    }
    
    ///
    /// Gives custom styling to the view.
    ///
    /// - parameter fieldColor: The color of the text field background.
    /// - parameter fontName: The name of the font used in the text field.
    /// - parameter textColor: The color of the text in the field.
    /// - parameter buttonColor: The color used for the adjustment buttons.
    /// - parameter decrementImage: Image that is used in place of standard minus SF symbol.
    /// - parameter incrementImage: Image that is used in place of standard plus SF symbol.
    ///
    func setStyle(fieldColor: UIColor, fontName: String, textColor: UIColor, buttonColor: UIColor, decrementImage: UIImage? = nil, incrementImage: UIImage? = nil) {
        
        valueTextField.backgroundColor = fieldColor
        valueTextField.font = UIFont(name: fontName, size: bounds.height / 4)
        valueTextField.textColor = textColor
        
        decrementImageView.tintColor = buttonColor
        if #available(iOS 13.0, *) { decrementImageView.image = UIImage(systemName: "minus") }
        if let decrementImage = decrementImage { decrementImageView.image = decrementImage }
        
        incrementImageView.tintColor = buttonColor
        if #available(iOS 13.0, *) { incrementImageView.image = UIImage(systemName: "plus") }
        if let incrementImage = incrementImage { incrementImageView.image = incrementImage }
    }
    
    ///
    /// Gives custom styling to the keyboard.
    ///
    /// - parameter backgroundColor: The color of the keyboard background.
    /// - parameter digitKeyColor: The color of digit keys (0-9) on the keyboard.
    /// - parameter actionKeyTextColor: The color of the text on digit keys.
    /// - parameter actionKeyColor: The color of action keys (ex: done) on the keyboard.
    /// - parameter actionKeyTextColor: The color of the text on action keys.
    /// - parameter fontName: The name of the font used on all keyboard buttons.
    /// - parameter backspaceButtonImage: An optional custom image for the backspace button.
    /// - parameter doneButtonText: Optional custom text for the done button.
    /// - parameter closeButtonImage: An optional custom image for the clear button.
    ///
    func setKeyboardStyle(backgroundColor: UIColor, digitKeyColor: UIColor, digitKeyTextColor: UIColor, actionKeyColor: UIColor, actionKeyTextColor: UIColor, fontName: String, backspaceButtonImage: UIImage?, doneButtonText: String?, closeButtonImage: UIImage?) {
        
        digitKeyboardView?.setStyle(backgroundColor: backgroundColor, digitKeyColor: digitKeyColor, digitKeyTextColor: digitKeyTextColor, actionKeyColor: actionKeyColor, actionKeyTextColor: actionKeyTextColor, fontName: fontName, backspaceButtonImage: backspaceButtonImage, doneButtonText: doneButtonText, closeButtonImage: closeButtonImage)
    }
}

// MARK: - Value Updates -

extension IncrementerView {
    
    ///
    /// Attempts to change the number in the text field to a new value.
    /// - note: The change can still be blocked at this point.
    ///
    /// - parameter newValue: The new value that will be populated in the text field.
    ///
    func changeValue(_ newValue: Int) {
        
        guard newValue <= maxValue && newValue >= minValue else {
            valueTextField.text = String(currentValue)
            return
        }
        
        guard delegate?.incrementerView(self, shouldUpdateValueTo: newValue, oldValue: currentValue) == true else { return }
        
        let oldValue: Int = currentValue
        delegate?.incrementerView(self, willUpdateValueTo: newValue, oldValue: oldValue)
        
        currentValue = newValue
        updateUI(for: newValue)
        
        delegate?.incrementerView(self, didUpdateValueTo: currentValue, oldValue: oldValue)
    }
    
    ///
    /// Updated UI to account for a new value.
    ///
    /// - parameter value: The new value to update for.
    ///
    private func updateUI(for value: Int) {
        
        valueTextField.text = String(value)
        valueTextField.isEnabled = isEnabled
        valueTextField.alpha = isEnabled ? 1.0 : fadedTextAlpha
        
        decrementButton.isEnabled = isEnabled && value > minValue
        decrementImageView.alpha = isEnabled && value > minValue ? 1.0 : fadedButtonAlpha
        
        incrementButton.isEnabled = isEnabled && value < maxValue
        incrementImageView.alpha = isEnabled && value < maxValue ? 1.0 : fadedButtonAlpha
    }
}

// MARK: - Text Field -

extension IncrementerView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.placeholder = textField.text
        textField.text = ""
    }
}

// MARK: - Digit Keyboard -

extension IncrementerView: DigitKeyboardViewDelegate {
    
    func digitKeyboardView(_ view: DigitKeyboardView, didSelectKeyOfType keyType: DigitKeyboardView.KeyType) {
        
        guard let existingText = valueTextField.text else { return }
        
        switch keyType {
            
        case .digit(let value):
            
            guard existingText.count < String(maxValue).count else { return }
            valueTextField.text = existingText + String(value)
        
        case .backspace:
            
            if existingText.count > 0 {
                 valueTextField.text?.remove(at: existingText.startIndex)
            }
        
        case .done, .close:
            valueTextField.resignFirstResponder()
            guard let enteredValue = Int(existingText) else {
                valueTextField.text = String(currentValue)
                return
            }
            changeValue(enteredValue)
        }
    }
}

// MARK: - Buttons -

extension IncrementerView {
    
    @IBAction func incrementButtonPressed(_ sender: UIButton) {
        changeValue(currentValue + 1)
    }
    
    @IBAction func decrementButtonPressed(_ sender: UIButton) {
        changeValue(currentValue - 1)
    }
}

// MARK: - Factory -

extension IncrementerView {
    
    class func create(startingValue: Int = 0, maxValue: Int = 10, minValue: Int = 0) -> IncrementerView {
        
        guard let incrementerView = UINib(nibName: "IncrementerView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? IncrementerView else { return IncrementerView(frame: CGRect.zero) }
        incrementerView.configure(startingValue: startingValue, maxValue: maxValue, minValue: minValue)
        return incrementerView
    }
}
