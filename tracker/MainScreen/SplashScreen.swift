//
//  SplashScreen.swift
//  tracker
//
//  Created by Александр  Сухинин on 13.07.2024.
//

import UIKit

final class SplashScreen: UIViewController {

    let userDefaultsGetter = UserDefaultsGetter.shared

    func switchToTabBar() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = MainTabBar()
        window.rootViewController = tabBarController
    }

    func switchToPageVC() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let pageController = OnboardingPageVC()
        window.rootViewController = pageController
    }

    override func viewWillAppear(_ animated: Bool) {
        if userDefaultsGetter.skip {
            switchToTabBar()
        } else {
            switchToPageVC()
        }
    }
}
