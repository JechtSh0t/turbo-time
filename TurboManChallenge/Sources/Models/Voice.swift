//
//  Voice.swift
//
//  Created by JechtSh0t on 2/25/25.
//  Copyright © 2025 Brook Street Games. All rights reserved.
//

import AVFoundation

///
/// A single voice that can speak text.
///
struct Voice: Codable, CaseWrappable {
    
    // MARK: - Properties -
    
    /// The unique Apple identifier for the voice. (e.g. "com.apple.ttsbundle.siri_Aaron_en-US_compact").
    let id: String
    /// The name of the voice. (e.g. "Aaron").
    let display: String
    
    var speechVoice: AVSpeechSynthesisVoice? { AVSpeechSynthesisVoice(identifier: id) }
}

// MARK: - All -

extension Voice {
    
    /// All available voices that speak English.
    static var allCases: [Voice] {
        var names: Set<String> = []
        return AVSpeechSynthesisVoice.speechVoices().sorted {
            $0.name < $1.name
        }.compactMap {
            guard $0.identifier.contains("en-"), !names.contains($0.name) else { return nil }
            names.insert($0.name)
            return Voice(id: $0.identifier, display: $0.name)
        }
    }
}
