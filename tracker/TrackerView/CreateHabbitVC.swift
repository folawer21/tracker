//
//  CreateHabbitVC.swift
//  tracker
//
//  Created by Александр  Сухинин on 29.05.2024.
//

import UIKit
protocol CreateHabbitDelegateProtocol: AnyObject{
    func addNewTracker(tracker: Tracker,categoryName : String)
    func deleteTracker(tracker: Tracker)
}
final class CreateHabbitVC: UIViewController{
    let viewModel = CategoriesViewModel()
    let isEditVC: Bool
    let tracker: Tracker?
    let categoryName: String?
    weak var delegate: CreateHabbitDelegateProtocol?
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    private var selectedTimetable: [WeekDay]?
    var selectedCategory: String?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    init(isEditVC: Bool, tracker: Tracker? = nil, categoryName: String? = nil){
        self.isEditVC = isEditVC
        self.tracker = tracker
        self.categoryName = categoryName
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Colors.blackBackgroundColor
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        let navTitleText = NSLocalizedString("create_habbit_vc_nav_title", comment: "")
        navigationItem.title = navTitleText
        collectionView.backgroundColor = Colors.blackBackgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor,constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -16)
        ])
        collectionView.register(TrackNameCell.self, forCellWithReuseIdentifier: "TextField")
        collectionView.register(ButtonCells.self, forCellWithReuseIdentifier: "ButtonCell")
        collectionView.register(EmojiCells.self, forCellWithReuseIdentifier: "EmojiCells")
        collectionView.register(ColorCells.self, forCellWithReuseIdentifier: "ColorCells")
        collectionView.register(CreateCancelButtonsCells.self, forCellWithReuseIdentifier: "CreateCancelButtons")
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//       
//    }
    
    private func getEnumTimetable(arr: [String]?) -> [WeekDay]?{
        var result: [WeekDay] = []
        guard let arr = arr else {return nil}
        for i in 0..<arr.count{
            guard let day = WeekDay(rawValue: arr[i]) else { break}
            result.append(day)
        }
        if result == [] {
            return nil
        }
        return result
    }
    
    private func getTimetable() -> [WeekDay]?{
        if selectedTimetable != nil{
            return selectedTimetable
        }
        guard let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 1)) as? ButtonCells else {return nil}
        let days = cell.daysArr
        let enumDays = getEnumTimetable(arr: days)
        selectedTimetable = enumDays
        return enumDays
    }
    
    private func getName() -> String?{
        guard let cell = collectionView.cellForItem(at: IndexPath(row:0,section: 0)) as? TrackNameCell,
              let name = cell.getName() else {return nil}
        return name
    }
    
    private func getColor() -> UIColor?{
        if selectedColor != nil {
            return selectedColor
        }
        guard let cell = collectionView.cellForItem(at: IndexPath(row: 0, section:3 )) as? ColorCells,
              let color = cell.getColor() else {print("Unable to get color");return nil}
        selectedColor = color
        return color
    }
    
    private func getCategory() -> String?{
        if selectedCategory != nil {
            return selectedCategory
        }
        guard let category = viewModel.getPickedCategory() else {
            return nil
        }
        selectedCategory = category
        return selectedCategory
    }
    
    private func getEmoji() -> String?{
        if selectedEmoji != nil{
            return selectedEmoji
        }
        guard let cell = collectionView.cellForItem(at: IndexPath(row:0,section: 2)) as? EmojiCells,
              let emoji = cell.getEmoji() else {print("Unable to get emoji");return nil}
        selectedEmoji = emoji
        return emoji
    }
//    func setData(tracker: Tracker, categoryName: String) {
//        guard let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? TrackNameCell else { print(2)
//            return }
//        print(1)
//        cell.textField.text = tracker.name
//        guard let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 1)) as? ButtonCells else {print(2)
//            return}
//        print(1)
//        var daysArray: [String] = []
//        for day in tracker.timetable {
//            daysArray.append(day.rawValue)
//        }
//        cell.setDays(days: daysArray)
//        cell.setCategory(name: categoryName)
//        guard let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 2)) as? EmojiCells else {print(2)
//            return}
//        print(1)
//        cell.setEmoji(emoji: tracker.emoji)
//        guard let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 3)) as? ColorCells else {print(2)
//            return}
//        print(1)
//        cell.setColor(color: tracker.color)
//        guard let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 4)) as? CreateCancelButtonsCells else {print(2)
//            return}
//        print(1)
//        cell.makeEditingScreen()
//    }
}

extension CreateHabbitVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextField", for: indexPath) as? TrackNameCell else {return UICollectionViewCell()}
            cell.textFieldDelegate = self
            if isEditVC {
                cell.textField.text = tracker?.name
            }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as? ButtonCells else {return UICollectionViewCell()}
            cell.delegate = self
            if isEditVC {
                guard let tracker = tracker,
                      let categoryName = categoryName else {return UICollectionViewCell()}
                var daysArray: [String] = []
                for day in tracker.timetable {
                    daysArray.append(day.rawValue)
                }
                cell.daysArr = daysArray
                cell.selectedCategory = categoryName
            }
            cell.setVM(vm: viewModel)
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCells", for: indexPath) as? EmojiCells else {print(2131231); return UICollectionViewCell()}
            cell.delegate = self
            cell.setupView()
            if isEditVC {
                guard let tracker = tracker else {return UICollectionViewCell()}
                cell.selectedEmoji = tracker.emoji
            }
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCells", for: indexPath) as? ColorCells else {print(2131231); return UICollectionViewCell()}
            cell.delegate = self
            cell.setupView()
            if isEditVC {
                guard let tracker = tracker else {return UICollectionViewCell()}
                cell.selectedColor = tracker.color
            }
            return cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateCancelButtons", for: indexPath) as? CreateCancelButtonsCells else {return UICollectionViewCell()}
            if isEditVC {
                cell.isEditing = true
            }
            cell.setupView()
            cell.delegate = self
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

extension CreateHabbitVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1{
            return CGSize(width: collectionView.bounds.width, height: 150)
        }else if indexPath.section == 2 || indexPath.section == 3 {
            return CGSize(width: collectionView.bounds.width, height: 204)
        }else if indexPath.section == 4{
            return CGSize(width: collectionView.bounds.width, height: 60)
        }else{
            return CGSize(width: collectionView.bounds.width, height: 75)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1{
            let sectionInsets = UIEdgeInsets(top: 24, left: 0, bottom: 32, right: 0)
            return sectionInsets
        }else if section == 2{
            return UIEdgeInsets(top: 0    , left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 2{
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SupplementaryView else {return UICollectionReusableView()}
            view.titleLabel.text = "Emoji"
            view.titleLabel.textColor = Colors.headerCollectionViewColor
            return view
        }else if indexPath.section == 3{
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SupplementaryView else {return UICollectionReusableView()}
            view.titleLabel.text = "Цвет"
            view.titleLabel.textColor = Colors.headerCollectionViewColor           
            return view
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 2 || section == 3{
            return CGSize(width: collectionView.frame.width, height: 18)
            
        }else{
            return CGSize.zero
        }
    }
}

extension CreateHabbitVC:ButtonCellDelegateProtocol{
    func timetableSettedDelegate(flag: Bool) {
        updateButtonEnabling()
    }
    func categoryWasChosen(category: String){
        selectedCategory = category
        updateButtonEnabling()
    }
    func showTimeTable(vc: TimeTableVC){
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCategoryVC(vc: CategoriesVC){
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CreateHabbitVC: TrackNameCellDelegateProtocol{
    func updateCreateButtonState(isEnabled: Bool){
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 4)) as? CreateCancelButtonsCells else {
            return}
        cell.updateCreateButtonState(isEnabled: isEnabled)
    }
    func textFieldDidChange(text: String) {
        updateButtonEnabling()
    }
}

extension CreateHabbitVC: EmojiCellsDelegateProtocol{
    func emojiWasChosen() {
        updateButtonEnabling()
    }
    
    func emojiWasUnchosen() {
        updateButtonEnabling()
    }
}

extension CreateHabbitVC: ColorCellsDelegateProtocol{
    func colorWasChosen() {
        updateButtonEnabling()
    }
    func colorWasUnchosen() {
        updateButtonEnabling()
    }
}

extension CreateHabbitVC{
    func updateButtonEnabling(){
        if (getName() != nil) &&  (getEmoji() != nil) && (getColor() != nil) && (getTimetable() != nil)  && (getCategory() != nil) {
            updateCreateButtonState(isEnabled: true)
        }else{
            updateCreateButtonState(isEnabled: false)
        }
    }
}

extension CreateHabbitVC: CreateCancelButtonsDelegateProtocol{
    func createButtonTappedDelegate(){
        guard let timetable = getTimetable(),
              let name = getName(),
              let emoji = getEmoji(),
              let color = getColor(),
              let categoryName = viewModel.getPickedCategory() else {return}
        let createdAt = Date()
        let id = UUID()
        let type = TrackerType.habbit
        let tracker = Tracker(id: id, type: type, name: name, emoji: emoji, color: color, createdAt: createdAt, timetable: timetable)
        delegate?.addNewTracker(tracker: tracker, categoryName: categoryName)
        dismiss(animated: true)
    }
    
    func cancelButtonTappedDelegate(){
        dismiss(animated: true)
    }
    
    func editButtonTappedDelegate() {
        guard let timetable = getTimetable(),
              let name = getName(),
              let emoji = getEmoji(),
              let color = getColor(),
              let newCategoryName = viewModel.getPickedCategory() else {return}
        let createdAt = Date()
        let id = UUID()
        let type = TrackerType.habbit
        let newTracker = Tracker(id: id, type: type, name: name, emoji: emoji, color: color, createdAt: createdAt, timetable: timetable)
        guard let tracker = tracker else {
            print("!@#!@#!@#!@#!@#")
            return
        }
        delegate?.deleteTracker(tracker: tracker)
        delegate?.addNewTracker(tracker: newTracker, categoryName: newCategoryName)
        print("Все ок CreateHabbit",delegate)
        dismiss(animated: true)
    }
}


