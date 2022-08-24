//
//  Int+Extensions.swift
//
//  Created by JechtSh0t on 8/24/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import Foundation

extension Int {
    
    var minutes: Int { return self * 60 }
    
    var timeFormatted: String? {
        let timeInterval = TimeInterval(self)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval)
    }
}
