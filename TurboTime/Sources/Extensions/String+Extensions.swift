//
//  String+Extensions.swift
//
//  Created by JechtSh0t on 2/25/25.
//  Copyright © 2025 Brook Street Games. All rights reserved.
//

extension String {
    
    var speechFormatted: String {
        self
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
    }
}
