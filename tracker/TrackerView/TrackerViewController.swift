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
    var currentDate: Date = Date()
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        let stubView = StubView(frame: self.view.safeAreaLayoutGuide.layoutFrame,title: "Что будем отслеживать?")
        
        
        view.addSubview(stubView)
        NSLayoutConstraint.activate([
            stubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        buildNavBar()
        view.backgroundColor = .white
        
    }
    
    @objc func addButtonTapped(){
        let vc = TrackerCreatingVC()
        let navVc = UINavigationController(rootViewController: vc)
        navigationController?.present(navVc, animated: true)
    }
    

    private func buildNavBar(){
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .black
        navigationItem.leftBarButtonItem = addButton
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        navigationItem.searchController = UISearchController(searchResultsController: nil)
    }
    
}
