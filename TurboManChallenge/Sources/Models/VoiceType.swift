//
//  VoiceType.swift
//
//  Created by JechtSh0t on 2/25/25.
//  Copyright © 2025 Brook Street Games. All rights reserved.
//

import AVFoundation

///
/// Voices that can speak text.
///
enum VoiceType: Codable, CaseWrappable {
    
    case americanChick, australianChick, britishChick, robotChick
    case britishDude
    
    /// A user-friendly string.
    var display: String {
        switch self {
        case .americanChick: return "US Chick"
        case .australianChick: return "AU Chick"
        case .britishChick: return "GB Chick"
        case .robotChick: return "AI Chick"
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
}
