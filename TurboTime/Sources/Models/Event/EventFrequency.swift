//
//  EventType.swift
//
//  Created by JechtSh0t on 2/24/25.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import BSGAppBasics

///
/// How often events appear.
///
enum EventFrequency: Int, CaseWrappable, Codable, Equatable, Displayable {
    case off = 0
    case low = 1
    case medium = 2
    case high = 3
    
    var display: String {
        switch self {
        case .off: "Off"
        case .low: "Low"
        case .medium: "Medium"
        case .high: "High"
        }
    }
}
