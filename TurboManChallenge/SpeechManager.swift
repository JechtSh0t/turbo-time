//
//  SpeechManager.swift
//  interval
//
//  Created by Phil on 10/16/19.
//  Copyright © 2019 Phil Rattazzi. All rights reserved.
//

import AVFoundation

// MARK: - Enumeration -

/// Convenient way of switching between voices.
enum Speaker {
    case australianGirl, britishDude, robotGirl, americanGirl, britishGirl
    
    /// Voice object.
    var voice: AVSpeechSynthesisVoice? {
        switch self {
        case .australianGirl: return AVSpeechSynthesisVoice(language: "en-AU")
        case .britishDude: return AVSpeechSynthesisVoice(language: "en-GB")
        case .robotGirl: return AVSpeechSynthesisVoice(language: "en-IE")
        case .americanGirl: return AVSpeechSynthesisVoice(language: "en-US")
        case .britishGirl: return AVSpeechSynthesisVoice(language: "en-ZA")
        }
    }
}

// MARK: - Class -

/// Able to have a variety of speakers speak any string.
final class SpeechManager {
    
    // MARK: - Public Members -
    
    static let shared = SpeechManager()
    
    // MARK: - Private Members -
    
    private let synthesizer = AVSpeechSynthesizer()
    
    // MARK: - Public Methods -
    
    ///
    /// Causes speaker to start reading the specified string.
    ///
    func speak(_ text: String) {
        
        stop()
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        utterance.voice = Speaker.americanGirl.voice
        synthesizer.speak(utterance)
    }
    
    ///
    /// Stops speaker dead in thier tracks.
    ///
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
