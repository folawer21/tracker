//
//  TrackerViewController.swift
//  tracker
//
//  Created by Александр  Сухинин on 16.04.2024.
//

import UIKit
//не работает создание привычки
final class TrackerViewController: UIViewController{
    var categories: [TrackerCategory] = []
    var filteredCategories: [TrackerCategory] = []
    var currentDate: Date = Date()
    var chosenFilter: Filtres = .all
    let datePicker = UIDatePicker()
    let imageView = UIImageView()
    let filterButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("filter_button", comment: ""), for: .normal)
        button.setTitleColor(Colors.white, for: .normal)
        button.backgroundColor = Colors.filter_blue
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let calendar = Calendar.current
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let stubView = StubView(frame: CGRect.zero, title: NSLocalizedString("emptyState.title", comment: ""),imageName: "stubView")
    
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
        ])
    }
    
    private func buildWithTracks(){
        removeStub()
        stubViewActive = false
        view.addSubview(collectionView)
        view.addSubview(filterButton)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.frame = self.view.safeAreaLayoutGuide.layoutFrame
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 115)
        ])
        collectionView.backgroundColor = Colors.blackBackgroundColor
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
        self.view.willRemoveSubview(filterButton)
        filterButton.removeFromSuperview()
        
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
        let categoryStore = TrackerCategoryStore(day:enumDay,date: currentDate)
        trackerStore.setCategoryStore(categoryStore: categoryStore)
        categoryStore.setTrackerStore(trackerStore: trackerStore)
        categoryStore.setRecordStore(recordStore: trackerRecordStore)
        trackerRecordStore.setTrackerStore(store: trackerStore)
        trackerStore.delegate = self
        categoryStore.delegate = self
        trackerRecordStore.delegate = self
        
        self.categoriesStore  = categoryStore
        self.trackerStore = trackerStore
        self.trackerRecordStore = trackerRecordStore
        view.backgroundColor = Colors.blackBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if trackerStore?.isEmpty == true{
            buildWithStub()
        }else{
            buildWithTracks()
        }
    }

    @objc func addButtonTapped(){
        let vc = TrackerCreatingVC()
        let navVc = UINavigationController(rootViewController: vc)
        vc.delegate = self
        navigationController?.present(navVc, animated: true)
    }
    
    @objc func filterButtonTapped() {
        let vc = FiltresVC()
        vc.delegate = self
        vc.chosenFilter = chosenFilter
        let navVc = UINavigationController(rootViewController: vc)
        navigationController?.present(navVc,animated: true)
    }

    private func buildNavBar(){
        let navItemText = NSLocalizedString("trackerVc_nav_title", comment: "")
        navigationItem.title = navItemText
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = Colors.addButtonColor
        navigationItem.leftBarButtonItem = addButton
        
        
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = Colors.datePickerColor
        datePicker.layer.cornerRadius = 20
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("tracker_viewController_search", comment: "")
        navigationItem.searchController = searchController
        
        
    }
    
    @objc func datePickerChanged(){
        if chosenFilter == .today {
            chosenFilter = .all
        }
        print("ASDASDASDASDASDASDASDASD")
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
        categoriesStore?.setDay(day: enumDay)
        categoriesStore?.setDate(date: currentDate)
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
    
    private func getDayOfWeek(from date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dayInWeek = dateFormatter.string(from: date)
            return dayInWeek
        }
    private func dayEnumFromDay(day: String) -> WeekDay{
        switch day{
            case "понедельник":
                return WeekDay.monday
            case "вторник":
                return WeekDay.tuesday
            case "среда":
                return WeekDay.wednesday
            case "четверг":
                return WeekDay.thursday
            case "пятница":
                return WeekDay.friday
            case "суббота":
                return WeekDay.saturday
            case "воскресенье":
                return WeekDay.sunday
            default:
                return WeekDay.sunday
        }
    }
    
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
        guard let tracker = trackerStore?.object(at: indexPath) else {return UICollectionViewCell()}
        let type = tracker.type
        var available = true
        if Calendar.current.compare(currentDate, to: Date(), toGranularity: .day) == .orderedDescending{
            available = false
        }
        if type == .habbit{
            guard let isDoneToday = trackerRecordStore?.isRecordedByDate(id: tracker.id, date: currentDate),
                  let daysCount = trackerRecordStore?.getTrackerDoneCount(id: tracker.id),
                  let isPinned = categoriesStore?.isPinnedById(trackerId: tracker.id) else {return UICollectionViewCell()}
            cell.configCell(track: tracker, days: daysCount, isDone: isDoneToday, availible: available,isPinned: isPinned)
        }
        if type == .single {
            guard let isDone = trackerRecordStore?.singleIsDone(id: tracker.id),
                  let isPinned = categoriesStore?.isPinnedById(trackerId: tracker.id) else {return UICollectionViewCell()}
            let daysCount = isDone ? 1 : 0
            cell.configCell(track: tracker, days: daysCount, isDone: isDone, availible: available, isPinned: isPinned)
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = trackerStore?.numberOfRowsInSection(section) else {fatalError()}
        return count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categoriesStore?.numberOfSections ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SupplementaryView else {return UICollectionReusableView()}
        view.titleLabel.text = categoriesStore?.getCategoryName(section: indexPath.section)
        view.titleLabel.textColor = Colors.headerCollectionViewColor
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
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

extension TrackerViewController: TrackerCreatingDelegateProtocol{
    func addNewTracker(tracker: Tracker, categoryName: String) {
        trackerStore?.addTracker(tracker, category: categoryName)
    }
    
    func deleteTracker(tracker: Tracker) {
        trackerStore?.deleteTracker(id: tracker.id)
        print("Все ок TrackerViewController")
    }
}


extension TrackerViewController: TrackCellDelegateProtocol{
    func deleteTrackerRecord(id: UUID) {
        trackerRecordStore?.deleteRecord(id: id, timetable: currentDate)
    }
    
    func addTrackerRecord(id: UUID) {
        trackerRecordStore?.makeNewRecord(id: id, timetable: currentDate)
    }
    
    func deleteTracker(id: UUID?) {
        let actionSheet = UIAlertController(title: nil, message: NSLocalizedString("confirm_delete", comment: ""), preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: NSLocalizedString("delete_cell", comment: ""), style: .default, handler: {
                [weak self ] (alert: UIAlertAction!) -> Void in
            self?.trackerStore?.deleteTracker(id: id)
            self?.reloadCollectionView()
            })
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel_action", comment: ""), style: .default, handler: {
               (alert: UIAlertAction!) -> Void in
            })
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet,animated: true,completion: nil)
    }
    
    func editTracker(id: UUID?) {
        guard let id = id,
              let tracker = trackerStore?.getTracker(id: id ),
              let categoryName = categoriesStore?.getCategoryNameById(by: id) else {return }
        if tracker.type == .single {
            let vc = CreateEventVC(isEditVC: true, tracker: tracker, categoryName: categoryName)
            let trackCreating = TrackerCreatingVC()
            trackCreating.delegate = self
            vc.delegate = trackCreating
            let navVc = UINavigationController(rootViewController: trackCreating)
            navVc.pushViewController(vc, animated: true)
            present(navVc,animated: true)
        } else {
            let vc = CreateHabbitVC(isEditVC: true, tracker: tracker, categoryName: categoryName)
            let trackCreating = TrackerCreatingVC()
            trackCreating.delegate = self
            vc.delegate = trackCreating
            let navVc = UINavigationController(rootViewController: trackCreating)
            navVc.pushViewController(vc, animated: true)
            present(navVc,animated: true)
        }
    }
    
    func pinTracker(id: UUID?,pinned: Bool) {
        guard let id = id else {return }
        if pinned {
            categoriesStore?.unpin(trackerId: id)
        } else {
            categoriesStore?.pin(trackerId: id)
        }
        collectionView.reloadData()
    }
    
    
}

extension TrackerViewController: TrackerStoreDelegate{
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        if stubViewActive{
            buildWithTracks()
            collectionView.reloadData()
        }
        collectionView.reloadData()
    }
}

extension TrackerViewController: TrackerCategoryStoreDelegate{
    func stote(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
    }
}


extension TrackerViewController: TrackerRecordStoreDelegateProtocol{
    func update(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
        collectionView.reloadData()
    }
}

extension TrackerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            categoriesStore?.updateCategoriesWithSearch(searchText: searchText)
            collectionView.reloadData()
        }
    }
}

extension TrackerViewController: FiltresVCDelegateProtocol {
    func filterDidChosen(filter: Filtres) {
        
        chosenFilter = filter
        switch chosenFilter {
        case .all:
            print("all")
            categoriesStore?.setFilter(filter: .all)
            collectionView.reloadData()
        case .today:
            datePicker.date = Date()
            datePickerChanged()
            categoriesStore?.setFilter(filter: .today)
            collectionView.reloadData()
        case .completed:
            categoriesStore?.setFilter(filter: .completed)
            collectionView.reloadData()
        case .uncompleted:
            categoriesStore?.setFilter(filter: .uncompleted)
            collectionView.reloadData()
        }
//        categoriesStore?.setFilter(filter: filter)
    }
}
