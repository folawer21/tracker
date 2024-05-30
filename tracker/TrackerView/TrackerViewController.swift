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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: "Track")
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        vc.delegate = self
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackerList.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SupplementaryView else {return UICollectionReusableView()}
        view.titleLabel.text = categories[indexPath.section].title
        return view
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 3.5, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
           return CGSize(width: collectionView.frame.width, height: 44) // Замените на ваш желаемый размер
       }
}


extension TrackerViewController: TrackerCreatingDelegateProtocol{
    func addNewTracker(tracker: Tracker, categoryName: String) {
        if categories.contains(where: {$0.title == categoryName}){
            guard var categoryIndex = categories.firstIndex(where: {$0.title == categoryName}) else {
                print("[addNewTracker]: TrackerViewController - не удалось получить структуру")
                return}
            let category = categories[categoryIndex]
            var temp = category.trackerList
            temp.append(tracker)
            let newCategory = TrackerCategory(title: categoryName, trackerList: temp)
            categories.remove(at: categoryIndex)
            categories.insert(newCategory, at: categoryIndex)
            
//            category = newCategory
//            guard let index = categories.firstIndex(of: category) else { 
//                print("[addNewTracker]: TrackerViewController - не удалось получить индекс")
//                return }
//            collectionView.performBatchUpdates{
//                collectionView.insertItems(at: [IndexPath(row: newCategory.trackerList.count - 1, section: index)])
//                }
            collectionView.reloadData()
        }else{
            if categories.isEmpty{
                removeStub()
                buildWithTracks()
            }
            let category = TrackerCategory(title: categoryName, trackerList: [tracker])
            categories.append(category)
//            let index = IndexPath(row: 0, section: categories.count - 1)
//            collectionView.performBatchUpdates{
//                collectionView.insertItems(at: [index])
//                }
            collectionView.reloadData()
        }
    }
}
