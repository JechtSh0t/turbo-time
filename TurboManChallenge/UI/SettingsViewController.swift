//
//  SettingsViewController.swift
//  JingleAllTheWay
//
//  Created by Phil on 12/9/20.
//

import UIKit

final class SettingsViewController: BaseViewController {
    
    // MARK: - UI -
    
    @IBOutlet private weak var showTimerButton: UIButton!
    @IBOutlet private weak var minimumTimeIncrementerContainer: UIView!
    private var minimumTimeIncrementerView: IncrementerView!
    @IBOutlet private weak var maximumTimeIncrementerContainer: UIView!
    private var maximumTimeIncrementerView: IncrementerView!
    @IBOutlet private weak var actionsIncrementerContainer: UIView!
    private var actionsIncrementerView: IncrementerView!
    @IBOutlet private weak var resetButton: UIButton!
    
    // MARK: - Setup -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        minimumTimeIncrementerView = buildIncrementerView(for: minimumTimeIncrementerContainer, tag: 1, min: 1, max: 10, startingValue: GameManager.shared.minimumRoundTime)
        maximumTimeIncrementerView = buildIncrementerView(for: maximumTimeIncrementerContainer, tag: 2, min: 1, max: 10, startingValue: GameManager.shared.maximumRoundTime)
        actionsIncrementerView = buildIncrementerView(for: actionsIncrementerContainer, tag: 3, min: 1, max: 5, startingValue: GameManager.shared.eventsPerRound)
        updateUI()
    }
    
    override func style() {
        
        super.style()
        
        resetButton.layer.borderWidth = 5.0
        resetButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func buildIncrementerView(for containerView: UIView, tag: Int, min: Int, max: Int, startingValue: Int) -> IncrementerView {
        
        let incrementerView = IncrementerView.create(startingValue: startingValue, maxValue: max, minValue: min)
        incrementerView.setStyle(fieldColor: .clear, fontName: "Chalkduster", textColor: .white, buttonColor: .white)
        incrementerView.setKeyboardStyle(backgroundColor: .darkGray, digitKeyColor: .black, digitKeyTextColor: .cyan, actionKeyColor: .lightGray, actionKeyTextColor: .black, fontName: "Arial", backspaceButtonImage: nil, doneButtonText: "Finito", closeButtonImage: nil)
        incrementerView.tag = tag
        incrementerView.delegate = self
    
        view.addSubview(incrementerView)
        incrementerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: incrementerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 120))
        view.addConstraint(NSLayoutConstraint(item: incrementerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 60))
        view.addConstraint(NSLayoutConstraint(item: incrementerView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: incrementerView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1.0, constant: 0))
        return incrementerView
    }
    
    private func updateUI() {
        
        showTimerButton.setTitle(GameManager.shared.shouldShowTimer ? "YES" : "NO", for: .normal)
        minimumTimeIncrementerView.changeValue(GameManager.shared.minimumRoundTime)
        maximumTimeIncrementerView.changeValue(GameManager.shared.maximumRoundTime)
        actionsIncrementerView.changeValue(GameManager.shared.eventsPerRound)
    }
}

// MARK: - Controls -

extension SettingsViewController: IncrementerViewDelegate {
    
    @IBAction private func showTimerButtonPressed(_ sender: UIButton) {
        GameManager.shared.shouldShowTimer.toggle()
        updateUI()
    }
    
    func incrementerView(_ view: IncrementerView, shouldUpdateValueTo newValue: Int, oldValue: Int) -> Bool {
        
        switch view.tag {
        case 1: return newValue <= GameManager.shared.maximumRoundTime
        case 2: return newValue >= GameManager.shared.minimumRoundTime
        default: return true
        }
    }
    
    func incrementerView(_ view: IncrementerView, didUpdateValueTo newValue: Int, oldValue: Int) {
        
        switch view.tag {
        case 1: GameManager.shared.minimumRoundTime = newValue
        case 2: GameManager.shared.maximumRoundTime = newValue
        case 3: GameManager.shared.eventsPerRound = newValue
        default: break
        }
    }
    
    @IBAction private func resetButtonPressed(_ sender: UIButton) {
        
        GameManager.shared.shouldShowTimer = GameManager.shared.defaultShowTimer
        GameManager.shared.minimumRoundTime = GameManager.shared.defaultMinimumRoundTime
        GameManager.shared.maximumRoundTime = GameManager.shared.defaultMaximumRoundTime
        GameManager.shared.eventsPerRound = GameManager.shared.defaultEventsPerRound
        updateUI()
    }
}
