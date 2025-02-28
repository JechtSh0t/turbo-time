//
//  View+Extensions.swift
//
//  Created by JechtSh0t on 2/24/25.
//  Copyright © 2025 Brook Street Games. All rights reserved.
//

import SwiftUI

extension View {
    
    func screenBackground() -> some View {
        ZStack {
            Color.mainBackground
                .ignoresSafeArea()
            self
        }
    }
}
