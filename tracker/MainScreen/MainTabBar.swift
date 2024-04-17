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
        trackerNavViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "trackerBarItem"), selectedImage: nil)
        
        
        let statisticViewController = UIViewController()
        statisticViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "statisticBarItem"), selectedImage: nil)
        
        
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = UIColor(named: "YPGray")?.cgColor
        self.viewControllers = [trackerNavViewController, statisticViewController]
    
        
    }
    
    
}
