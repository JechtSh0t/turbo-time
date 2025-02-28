//
//  EventType.swift
//
//  Created by JechtSh0t on 2/22/25.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import Foundation

///
/// Types of events.
///
enum EventType: Codable, Equatable, Hashable {
    case single(EventFrequency)
    case repeatable(EventFrequency)
    case timed(TimeInterval, Bool)
}
