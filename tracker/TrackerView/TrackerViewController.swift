//
//  TrackerViewController.swift
//  tracker
//
//  Created by Александр  Сухинин on 16.04.2024.
//

import UIKit

final class TrackerViewController: UIViewController{
    
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        let stubView = StubView(frame: self.view.safeAreaLayoutGuide.layoutFrame)
        
        
        view.addSubview(stubView)
        NSLayoutConstraint.activate([
            stubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        buildNavBar()
        view.backgroundColor = .white
        
    }
    
    @objc func addButtonTapped(){
        
    }
    
    
    private func buildNavBar(){
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .black
        navigationItem.leftBarButtonItem = addButton
    }
    
}
