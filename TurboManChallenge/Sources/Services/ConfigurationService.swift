//
//  ConfigurationService.swift
//
//  Created by JechtSh0t on 2/25/25.
//  Copyright © 2025 Brook Street Games. All rights reserved.
//

import Foundation

protocol ConfigurationServiceProtocol {
    func getConfiguration() -> Configuration
    func setConfiguration(_ configuration: Configuration)
}

struct ConfigurationServiceMock: ConfigurationServiceProtocol {
    private let configuration: Configuration
    init(configuration: Configuration = .default) {
        self.configuration = configuration
    }
    func getConfiguration() -> Configuration { configuration }
    func setConfiguration(_ configuration: Configuration) {}
}

///
/// A service for game configuration.
///
struct ConfigurationService: ConfigurationServiceProtocol {
    
    struct Constant {
        static let configurationKey = "ConfigurationService.Configuration"
    }
    
    func getConfiguration() -> Configuration {
        UserDefaults.standard.getObject(Configuration.self, forKey: Constant.configurationKey) ?? .default
    }
    
    func setConfiguration(_ configuration: Configuration) {
        UserDefaults.standard.setObject(configuration, forKey: Constant.configurationKey)
    }
}
