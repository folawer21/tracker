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
    let collectionView = UICollectionView()
    let stubView = StubView(frame: CGRect.zero, title: "Что будем отслеживать?")
    
    private func buildWithStub(){
        stubView.frame = self.view.safeAreaLayoutGuide.layoutFrame
        view.addSubview(stubView)
        NSLayoutConstraint.activate([
            stubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func buildWithTracks(){
        view.addSubview(collectionView)
        collectionView.frame = self.view.safeAreaLayoutGuide.layoutFrame
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: "Track")
    }
    
    private func removeStub(){
        self.view.willRemoveSubview(stubView)
        stubView.removeFromSuperview()
    }
    private func removeCollection(){
        self.view.willRemoveSubview(collectionView)
        collectionView.removeFromSuperview()
    }
    override func viewDidLoad() {
        buildNavBar()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if categories.isEmpty{
            buildWithStub()
        }else{
            buildWithTracks()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if categories.isEmpty{
            removeStub()
        }else{
            removeCollection()
        }
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

extension TrackerViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Track", for: indexPath) as? TrackCell else {return UICollectionViewCell()}
        let tracker = categories[indexPath.section].trackerList[indexPath.row]
        cell.configCell(track: tracker)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackerList.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
}
