//
//  MainTabBar.swift
//  tracker
//
//  Created by Александр  Сухинин on 16.04.2024.
//

import UIKit

final class MainTabBar: UITabBarController {
    
    override func viewDidLoad() {
        let trackerNavViewController = UINavigationController(rootViewController: TrackerViewController())
        let trackerTitle = NSLocalizedString("tab_bar_trackers", comment: "")
        trackerNavViewController.tabBarItem = UITabBarItem(title: trackerTitle, image: UIImage(named: "trackerBarItem"), selectedImage: nil)
        let statisticViewController = UIViewController()
        let statisticTitle = NSLocalizedString("tab_bar_statistics", comment: "")
        statisticViewController.tabBarItem = UITabBarItem(title: statisticTitle, image: UIImage(named: "statisticBarItem"), selectedImage: nil)
    
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = UIColor(named: "YPGray")?.cgColor
        self.viewControllers = [trackerNavViewController, statisticViewController]
    
        
    }
    
    
}
