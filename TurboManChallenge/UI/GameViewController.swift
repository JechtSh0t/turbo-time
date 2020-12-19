//
//  GameViewController.swift
//  JingleAllTheWay
//
//  Created by Phil on 12/9/20.
//

import UIKit

final class GameViewController: BaseViewController {

    // MARK: - UI -
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var gameButton: UIButton!
    
    // MARK: - Setup -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        GameManager.shared.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        timeLabel.isHidden = !GameManager.shared.shouldShowTimer
    }
}

// MARK: - Countdown -

extension GameViewController: GameManagerDelegate {
    
    @IBAction private func gameButtonPressed(_ sender: UIButton) {
        
        enableUI(false)
        GameManager.shared.startRound()
    }
    
    func gameManager(_ gameManager: GameManager, didBeginRoundWithTime time: Int) {
        timeLabel.text = GameManager.shared.formatTime(seconds: time)
    }
    
    func gameManager(_ gameManager: GameManager, didUpdateRemainingTime remainingTime: Int, roundOver: Bool) {
        
        timeLabel.text = GameManager.shared.formatTime(seconds: remainingTime)
        
        switch remainingTime {
        case 3: SpeechManager.shared.speak("3")
        case 2: SpeechManager.shared.speak("2")
        case 1: SpeechManager.shared.speak("1")
        case 0:
            SoundManager.shared.playSound("turbo-time")
            performEvents()
        default: break
        }
    }
}

// MARK: - Events -

extension GameViewController {
    
    private func performEvents() {
        
        GameManager.shared.generateEvents()
        
        let alertController = UIAlertController(title: "Turbo Time", message: "Ready pussies?", preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        alertController.addAction(UIAlertAction(title: "Start Events", style: .default, handler: { _ in
            self.showNextEvent()
        }))
    }
    
    private func showNextEvent() {
        
        guard let eventMessage = GameManager.shared.nextEvent() else {
            enableUI(true)
            return
        }
        
        SpeechManager.shared.speak(eventMessage)
        showAlert(forEventMessage: eventMessage, completion: {
            self.showNextEvent()
        })
    }
    
    private func enableUI(_ isEnabled: Bool) {
        
        gameButton.setTitle(isEnabled ? "Start Round" : "Waiting for Event...", for: .normal)
        gameButton.isEnabled = isEnabled
        tabBarController?.tabBar.isUserInteractionEnabled = isEnabled
    }
}
