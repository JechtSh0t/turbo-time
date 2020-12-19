//
//  DigitKeyboardView.swift
//  incrementer-view
//
//  Created by Phil on 7/22/20.
//  Copyright © 2020 Phil Rattazzi. All rights reserved.
//

import UIKit

// MARK: - Delegate -

protocol DigitKeyboardViewDelegate: class {

    /// Called when any key on the keyboard is pressed. The user can determine which key was pressed using *keyType*, and take appropriate action.
    func digitKeyboardView(_ view: DigitKeyboardView, didSelectKeyOfType keyType: DigitKeyboardView.KeyType)
}

// MARK: - Class -

final class DigitKeyboardView: UIView {

    // MARK: - Public Properties -

    weak var delegate: DigitKeyboardViewDelegate?
    
    // MARK: - UI -
    
    @IBOutlet private var digitButtons: [UIButton]!
    @IBOutlet private var actionButtons: [UIButton]!
}

// MARK: - Configuration -

extension DigitKeyboardView {
    
    ///
    /// Quick helper method with limited control over colors and default font.
    ///
    /// - parameter backgroundColor: The color of the keyboard background.
    /// - parameter keyColor: The color of all keyboard keys.
    /// - parameter textColor: The color of the text on all keys.
    ///
    func setStyle(backgroundColor: UIColor, keyColor: UIColor, textColor: UIColor) {
        setStyle(backgroundColor: backgroundColor, digitKeyColor: keyColor, digitKeyTextColor: textColor, actionKeyColor: keyColor, actionKeyTextColor: textColor, fontName: "Arial", backspaceButtonImage: nil, doneButtonText: nil, closeButtonImage: nil)
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
    func setStyle(backgroundColor: UIColor, digitKeyColor: UIColor, digitKeyTextColor: UIColor, actionKeyColor: UIColor, actionKeyTextColor: UIColor, fontName: String, backspaceButtonImage: UIImage?, doneButtonText: String?, closeButtonImage: UIImage?) {
        
        self.backgroundColor = backgroundColor
        
        for button in digitButtons + actionButtons {
            
            button.titleLabel?.font = UIFont(name: fontName, size: button.titleLabel!.font.pointSize)
            button.layer.cornerRadius = 6.0
            
            guard let keyType = KeyType.keyType(for: button.tag) else { return }
            
            if case .digit = keyType {
                button.backgroundColor = digitKeyColor
                button.setTitleColor(digitKeyTextColor, for: .normal)
            } else {
                
                button.backgroundColor = actionKeyColor
                button.setTitleColor(actionKeyTextColor, for: .normal)
                button.tintColor = actionKeyTextColor
                
                switch keyType {
                case .backspace: if backspaceButtonImage != nil { button.setImage(backspaceButtonImage, for: .normal) }
                case .done: if doneButtonText != nil { button.setTitle(doneButtonText, for: .normal) }
                case .close: if closeButtonImage != nil { button.setImage(closeButtonImage, for: .normal) }
                default: break
                }
            }
        }
    }
    
    ///
    /// This will remove the toolbar from the given responder
    ///
    /// - parameter control: the responder to stip toolbar from
    ///
    fileprivate func setupResponder(_ responder: UIResponder!) {

        let item: UITextInputAssistantItem = (responder.inputAssistantItem)

        item.leadingBarButtonGroups = []
        item.trailingBarButtonGroups = []
    }
}

// MARK: - Actions -

extension DigitKeyboardView {

    ///
    /// This handle when a key (button) is pressed and released on the custom keyboard view
    ///
    @IBAction private func keyPressed(_ button: UIButton) {

        guard let keyType = KeyType.keyType(for: button.tag) else { return }
        delegate?.digitKeyboardView(self, didSelectKeyOfType: keyType)
    }
}

// MARK: - Embedded Objects -

extension DigitKeyboardView {
    
    enum KeyType {
        
        case digit(_ value: Int)
        case backspace
        case done
        case close
        
        static func keyType(for tag: Int) -> KeyType? {
            
            switch tag {
            case 0...9: return digit(tag)
            case 10: return .backspace
            case 11: return .done
            case 12: return .close
            default: return nil
            }
        }
    }
}

// MARK: - Factory -

extension DigitKeyboardView {
    
    class func create() -> DigitKeyboardView {

        guard let digitKeyboardView = UINib(nibName: "DigitKeyboardView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? DigitKeyboardView else { return DigitKeyboardView(frame: CGRect.zero) }
        return digitKeyboardView
    }
}
