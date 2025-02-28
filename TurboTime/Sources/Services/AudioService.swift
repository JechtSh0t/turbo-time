//
//  SpeachService.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import AVFoundation
import BSGAppBasics

protocol AudioServiceProtocol {
    func play(_ soundName: String)
    func speak(_ text: String, voice: AVSpeechSynthesisVoice)
    func stop()
}

struct AudioServiceMock: AudioServiceProtocol {
    func play(_ soundName: String) {}
    func speak(_ text: String, voice: AVSpeechSynthesisVoice) {}
    func stop() {}
}

///
/// A service for playing sounds and speaking text.
///
struct AudioService: AudioServiceProtocol {
    
    // MARK: - Properties -
    
    private let generator = AudioGenerator()
    private let synthesizer = AVSpeechSynthesizer()
    
    // MARK: - Initializers -
    
    init() {}
}

// MARK: - Sound -

extension AudioService {
    
    ///
    /// Play a sound.
    /// - parameter soundName: The filename of the sound.
    ///
    func play(_ soundName: String) {
        stop()
        generator.playSound(soundName)
    }
}

// MARK: - Speech -

extension AudioService {
    
    ///
    /// Start speaking.
    /// - parameter text: The text to be spoken.
    /// - parameter voice: The voice to speak in.
    ///
    func speak(_ text: String, voice: AVSpeechSynthesisVoice) {
        stop()
        let utterance = AVSpeechUtterance(string: text.speechFormatted)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        utterance.voice = voice
        synthesizer.speak(utterance)
    }
    
    ///
    /// Stop speaking.
    ///
    func stop() {
        generator.stopSound()
        synthesizer.stopSpeaking(at: .immediate)
    }
}
