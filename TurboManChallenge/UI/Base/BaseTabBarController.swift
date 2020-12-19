
//
//  BaseTabBarController.swift
//  MartianTimes
//
//  Created by Phil on 9/5/20.
//  Copyright © 2020 Phil Rattazzi. All rights reserved.
//
import UIKit

///
/// Contains base functionality for all Tab Bar Controllers.
///
class BaseTabBarController: UITabBarController {
    
    // MARK: - Setup -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        style()
    }
    
    ///
    /// Style adjustments.
    ///
    func style() {
        
        tabBar.barTintColor = .white
        tabBar.tintColor = .christmasRed
        tabBar.unselectedItemTintColor = UIColor.black
    }
}

// MARK: - Interface Style Change -
extension BaseTabBarController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        style()
    }
}
