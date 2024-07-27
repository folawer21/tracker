//
//  OnboardingView.swift
//  tracker
//
//  Created by Александр  Сухинин on 13.07.2024.
//

import UIKit

final class OnboardingPageVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    let userDefGetter = UserDefaultsGetter()
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .brown
        pageControl.pageIndicatorTintColor = .orange
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.titleLabel?.textColor = .white
        return button
    }()
    let texts = [
        NSLocalizedString(
            "onboard_text_first",
            comment: ""
        ),
        NSLocalizedString(
            "onboard_text_second",
            comment: ""
        )
    ]
    let images = [UIImage(named: "1"), UIImage(named: "2")]
    lazy var pages: [UIViewController] = {
        let first = OnboardingPageScreen(text: texts[0])
        first.backgroundImage.image = images[0]
        let second = OnboardingPageScreen(text: texts[1])
        second.backgroundImage.image = images[1]
        return [first, second]
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        let techonologyText = NSLocalizedString("onboard_button_text", comment: "")
        nextButton.setTitle(techonologyText, for: .normal)
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -69),
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nextButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 624),
            pageControl.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -24),
            pageControl.heightAnchor.constraint(equalToConstant: 6),
            pageControl.widthAnchor.constraint(equalToConstant: 18)
        ])
    }
    func switchToTabBar() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = MainTabBar()
        window.rootViewController = tabBarController
    }
    @objc func nextButtonTapped() {
        userDefGetter.setSkip(skip: true)
        switchToTabBar()
    }
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        let prevIndex = index - 1
        guard prevIndex >= 0 else {
            return nil
        }
        return pages[prevIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        let prevIndex = index + 1
        guard prevIndex < pages.count else {
            switchToTabBar()
            return nil
        }
        return pages[prevIndex]
    }
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let currentVC = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentVC) {
            pageControl.currentPage = currentIndex
        }
    }
}
