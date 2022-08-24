//
//  Speaker.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import AVFoundation

enum VoiceType {
    
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

///
/// Reads text using a synthesized voice.
///
struct Speaker {
    
    // MARK: - Properties -
    
    let voiceType: VoiceType
    private let synthesizer = AVSpeechSynthesizer()
    
    // MARK: - Public Methods -
    
    ///
    /// Causes speaker to start reading the specified string.
    ///
    /// - parameter text: The text to be spoken.
    ///
    func speak(_ text: String) {
        
        stop()
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        utterance.voice = voiceType.voice
        synthesizer.speak(utterance)
    }
    
    ///
    /// Stop the speaker.
    ///
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
