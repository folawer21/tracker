//
//  TrackerViewController.swift
//  tracker
//
//  Created by Александр  Сухинин on 16.04.2024.
//

import UIKit

final class TrackerViewController: UIViewController{
    var categories: [TrackerCategory] = []
    var filteredCategories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate: Date = Date()
    let datePicker = UIDatePicker()
    let imageView = UIImageView()
    let calendar = Calendar.current
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let stubView = StubView(frame: CGRect.zero, title: "Что будем отслеживать?")
    
    var trackerStore: TrackerStoreProtocol?
    var categoriesStore: TrackerCategoryStoreProtocol?
    var trackerRecordStore: TrackerRecordStoreProtocol?
    var stubViewActive: Bool = true
    private func buildWithStub(){
        removeCollection()
        stubView.frame = self.view.safeAreaLayoutGuide.layoutFrame
        stubViewActive = true
        view.addSubview(stubView)
        NSLayoutConstraint.activate([
            stubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func buildWithTracks(){
        removeStub()
        stubViewActive = false
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        
        let date = datePicker.date
        guard let formattedDate = formatDate(date: date) else {
            print("[updateFilteredCategories] TrackerViewController - unable to get Date")
            return
        }
        currentDate = formattedDate
        let day = getDayOfWeek(from: currentDate)
        let enumDay = dayEnumFromDay(day: day)
        
        let trackerRecordStore = TrackerRecordStore()
        let trackerStore = TrackerStore(day: enumDay)
        let categoryStore = TrackerCategoryStore()
        trackerStore.setCategoryStore(categoryStore: categoryStore)
        categoryStore.setTrackerStore(trackerStore: trackerStore)
        trackerStore.delegate = self
        categoryStore.delegate = self
        trackerRecordStore.delegate = self
        
        self.categoriesStore  = categoryStore
        self.trackerStore = trackerStore
        self.trackerRecordStore = trackerRecordStore
        
        view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if trackerStore?.isEmpty == true{
            buildWithStub()
        }else{
            buildWithTracks()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
//        if trackerStore?.isEmpty == true{
//            removeStub()
//        }else{
//            removeCollection()
//        }
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
        
        
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        navigationItem.searchController = UISearchController(searchResultsController: nil)
    }
    
    @objc func datePickerChanged(){
        filterByDate()
    }
    
    private func filterByDate(){
        let date = datePicker.date
        guard let formattedDate = formatDate(date: date) else {
            print("[updateFilteredCategories] TrackerViewController - unable to get Date")
            return
        }
        currentDate = formattedDate
        let day = getDayOfWeek(from: currentDate)
        let enumDay = dayEnumFromDay(day: day)
        trackerStore?.setDay(day: enumDay)
        guard let flag = trackerStore?.isEmpty else {return }
        if !flag{
            if stubViewActive{
                buildWithTracks()
                collectionView.reloadData()
            }
            collectionView.reloadData()
        }else{
            buildWithStub()
        }
            


    }
//    private func updateFilteredCategories(){
//        let date = datePicker.date
//        guard let formattedDate = formatDate(date: date) else {
//            print("[updateFilteredCategories] TrackerViewController - unable to get Date")
//            return
//        }
//        currentDate = formattedDate
//        let isLater = currentDate > Date() ? true : false
//        enablePlusButtonChecking(flag: isLater)
//        let day = getDayOfWeek(from: currentDate)
//        let enumDay = dayEnumFromDay(day: day)
//        filterTrackersByDays(day: enumDay)
//        collectionView.reloadData()
//    }
//    private func filterTrackersByDays(day: WeekDay){
//        filteredCategories.removeAll()
//        for i in 0..<categories.count{
//            let category = categories[i]
//            for j in 0..<category.trackerList.count{
//                let tracker = categories[i].trackerList[j]
//                if tracker.timetable.contains(where: {$0 == day}) {
//                    if filteredCategories.contains(where: {$0 == category}){
//                        guard let categoryIndex = filteredCategories.firstIndex(where: {$0 == category}) else {
//                            print("[filterTrackersByDays]: TrackerViewController - не удалось получить структуру")
//                            return}
//                        let category = filteredCategories[categoryIndex]
//                        var temp = category.trackerList
//                        temp.append(tracker)
//                        let newCategory = TrackerCategory(title: category.title, trackerList: temp)
//                        filteredCategories.remove(at: categoryIndex)
//                        filteredCategories.insert(newCategory, at: categoryIndex)
//                    }else{
//                        let newFilteredCategory = TrackerCategory(title: category.title, trackerList: [tracker])
//                        filteredCategories.append(newFilteredCategory)
//                    }
//                }
//            }
//        }
//    }
    
    private func getDayOfWeek(from date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dayInWeek = dateFormatter.string(from: date)
            return dayInWeek
        }
    private func dayEnumFromDay(day: String) -> WeekDay{
        switch day{
            case "Monday":
                return WeekDay.monday
            case "Tuesday":
                return WeekDay.tuesday
            case "Wednesday":
                return WeekDay.wednesday
            case "Thursday":
                return WeekDay.thursday
            case "Friday":
                return WeekDay.friday
            case "Saturday":
                return WeekDay.saturday
            default:
                return WeekDay.sunday
        }
    }
//    private func enablePlusButtonChecking(flag: Bool){
//        for i in 0..<filteredCategories.count{
//            let category = filteredCategories[i]
//            for j in 0..<category.trackerList.count{
//                let indexPath = IndexPath(row: j, section: i)
//                guard let cell = collectionView.cellForItem(at: indexPath) as? TrackCell else {
//                    print("[blockPlusButton] TrackerViewController не удалось получить ячейку")
//                    break}
//                if flag{
//                    cell.disableButton()
//                    cell.buttonDidntTapped()
//                    return
//                }
//                let tracker = category.trackerList[j]
//                let id = tracker.id
//                
//                for record in completedTrackers{
//                    if record.id == id && record.timetable == currentDate{
//                        cell.buttonAlreadyTapped()
//                        return
//                    }
//                }
//                cell.enableButton()
//                cell.buttonDidntTapped()
//            }
//        }
//    }
    
    func formatDate(date: Date) -> Date?{
        let components = calendar.dateComponents([.year,.month,.day], from: date)
        guard let year = components.year, let month = components.month, let day = components.day else{
            return nil
        }
        var newComponents = DateComponents()
        newComponents.year = year
        newComponents.month = month
        newComponents.day = day
        guard let newDate = calendar.date(from: newComponents) else {return nil}
        return newDate
    }
}

extension TrackerViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Track", for: indexPath) as? TrackCell else {return UICollectionViewCell()}
//        let tracker = filteredCategories[indexPath.section].trackerList[indexPath.row]
        guard let tracker = trackerStore?.object(at: indexPath),
              let isDoneToday = trackerRecordStore?.isRecordedByDate(id: tracker.id, date: currentDate)
              else {return UICollectionViewCell()}
        
        cell.configCell(track: tracker)
        if isDoneToday{
            cell.buttonAlreadyTapped()
        }else{
            cell.buttonDidntTapped()
            if Calendar.current.compare(currentDate, to: Date(), toGranularity: .day) == .orderedDescending{
                cell.disableButton()
            }
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return filteredCategories[section].trackerList.count
//        print(trackerStore?.numberOfRowsInSection(section))
//        print(44444444)
//        guard let trackerStore = trackerStore else {return 0}
//        
//        return trackerStore.numberOfRowsInSection(section)
        guard let count = trackerStore?.numberOfRowsInSection(section) else {fatalError()}
        return count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categoriesStore?.numberOfSections ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SupplementaryView else {return UICollectionReusableView()}
//        view.titleLabel.text = filteredCategories[indexPath.section].title
        view.titleLabel.text = categoriesStore?.getCategoryName(section: indexPath.section)
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
           return CGSize(width: collectionView.frame.width, height: 44)
       }
}

extension TrackerViewController: TrackerCreatingDelegateProtocol{
    func addNewTracker(tracker: Tracker, categoryName: String) {
        trackerStore?.addTracker(tracker, category: categoryName)
    }
}


extension TrackerViewController: TrackCellDelegateProtocol{
    func deleteTrackerRecord(id: UUID) {
        guard let recordIndex = completedTrackers.firstIndex(where: {
            $0.id == id
        })else{
            print("[deleteTrackerRecord] TrackerViewController - unable to get recordIndex ")
            return
        }
        completedTrackers.remove(at: recordIndex)
    }
    
    func addTrackerRecord(id: UUID) {
        let date = currentDate
        let trackerRecord = TrackerRecord(id: id, timetable: date)
        completedTrackers.append(trackerRecord)
    }
}

extension TrackerViewController: TrackerStoreDelegate{
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        if stubViewActive{
            buildWithTracks()
            collectionView.reloadData()
        }
        collectionView.reloadData()
//        collectionView.performBatchUpdates{
//            let insertedIndexes = update.insertedIndexes.map{IndexPath(item: $0, section: 0)}
//            collectionView.insertItems(at: insertedIndexes)
//        }
//        collectionView.reloadData()
    }
}

extension TrackerViewController: TrackerCategoryStoreDelegate{
    func stote(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
    }
}


extension TrackerViewController: TrackerRecordStoreDelegateProtocol{
    func update(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
        let indexes = update.updatedIndexed.map{IndexPath(item: $0, section: 0)}
        collectionView.performBatchUpdates{
            collectionView.reloadItems(at: indexes)
        }
    }
}
