//
//  MainTabBar.swift
//  tracker
//
//  Created by Александр  Сухинин on 16.04.2024.
//

import UIKit

final class MainTabBar: UITabBarController {
    
    override func viewDidLoad() {
        view.backgroundColor = Colors.blackBackgroundColor
        self.tabBar.backgroundColor = Colors.blackBackgroundColor
        let trackerNavViewController = UINavigationController(rootViewController: TrackerViewController())
        trackerNavViewController.navigationBar.backgroundColor = Colors.blackBackgroundColor
        trackerNavViewController.navigationBar.tintColor = Colors.stubTextLabelColor
        let trackerTitle = NSLocalizedString("tab_bar_trackers", comment: "")
        trackerNavViewController.tabBarItem = UITabBarItem(title: trackerTitle, image: UIImage(named: "trackerBarItem"), selectedImage: nil)
        let statisticViewController = UIViewController()
        let statisticTitle = NSLocalizedString("tab_bar_statistics", comment: "")
        statisticViewController.tabBarItem = UITabBarItem(title: statisticTitle, image: UIImage(named: "statisticBarItem"), selectedImage: nil)
    
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = Colors.tabBarBorderColor.cgColor
        self.viewControllers = [trackerNavViewController, statisticViewController]
    
        
    }
    
    
}
