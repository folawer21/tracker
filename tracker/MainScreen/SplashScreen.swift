//
//  SplashScreen.swift
//  tracker
//
//  Created by Александр  Сухинин on 13.07.2024.
//

import UIKit

final class SplashScreen: UIViewController {

    private let userDefaultsGetter = UserDefaultsGetter.shared

    private func switchToTabBar() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = MainTabBar()
        window.rootViewController = tabBarController
    }

    private func switchToPageVC() {
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
