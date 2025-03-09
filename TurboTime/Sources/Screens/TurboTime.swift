//
//  TurboTime.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

@main
struct TurboTime: App {
    
    // MARK: - Properties -
    
    let coordinator = RootCoordinator()
    
    // MARK: - UI -
    
    var body: some Scene {
        WindowGroup {
            RootCoordinatorView(coordinator: coordinator)
        }
    }
}
