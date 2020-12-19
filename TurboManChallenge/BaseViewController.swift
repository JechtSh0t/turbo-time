//
//  BaseViewController.swift
//  interval
//
//  Created by Phil on 10/15/19.
//  Copyright © 2019 Phil Rattazzi. All rights reserved.
//

import UIKit

///
/// Base class for all view controllers.
///
class BaseViewController: UIViewController {
    
    // MARK: - Public Members -
    
    /// Reference to *RootViewController* to handle global events from other VCs.
    weak var navigationDelegate: NavigationDelegate?
}

// MARK: - Alerts -

extension BaseViewController {
    
    func showAlert(withTitle title: String?, message: String, completion: Closure?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in completion?() })
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(for error: IntervalError) {
        showAlert(withTitle: "Error", message: error.localizedDescription, completion: nil)
    }
    
    func showAlert(for error: Error) {
        showAlert(withTitle: "Error", message: error.localizedDescription, completion: nil)
    }
}
