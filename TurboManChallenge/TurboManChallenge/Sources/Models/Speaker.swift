//
//  Speaker.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import AVFoundation

enum VoiceType: Codable, CaseIterable {
    
    case americanChick, australianChick, britishChick, robotChick
    case britishDude
    
    /// A user-friendly title.
    var title: String {
        switch self {
        case .americanChick: return "US Chick"
        case .australianChick: return "AU Chick"
        case .britishChick: return "GB Chick"
        case .robotChick: return "Robot Chick"
        case .britishDude: return "GB Dude"
        }
    }
    
    /// Voice object.
    var voice: AVSpeechSynthesisVoice? {
        switch self {
        case .americanChick: return AVSpeechSynthesisVoice(language: "en-US")
        case .australianChick: return AVSpeechSynthesisVoice(language: "en-AU")
        case .britishChick: return AVSpeechSynthesisVoice(language: "en-ZA")
        case .robotChick: return AVSpeechSynthesisVoice(language: "en-IE")
        case .britishDude: return AVSpeechSynthesisVoice(language: "en-GB")
        }
    }
    
    /// Cycles through available voices.
    var next: VoiceType {
        
        let voices = VoiceType.allCases
        let index = voices.firstIndex(of: self)!
        return index == voices.count - 1 ? voices[0] : voices[index + 1]
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
