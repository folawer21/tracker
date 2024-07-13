//
//  CreateEventVC.swift
//  tracker
//
//  Created by Александр  Сухинин on 29.05.2024.
//
import UIKit
protocol CreateEventDelegateProtocol: AnyObject{
    func addNewTracker(tracker: Tracker,categoryName : String)
}
final class CreateEventVC: UIViewController{
    let cancelButton = UIButton()
    let createButton = UIButton()
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    weak var delegate: CreateEventDelegateProtocol?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.title = "Новая привычка"
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
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: "EventCell")
        collectionView.register(EmojiCells.self, forCellWithReuseIdentifier: "EmojiCells")
        collectionView.register(ColorCells.self, forCellWithReuseIdentifier: "ColorCells")
        collectionView.register(CreateCancelButtonsCells.self, forCellWithReuseIdentifier: "CreateCancelButtons")
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
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
    
    private func getEmoji() -> String?{
        if selectedEmoji != nil{
            return selectedEmoji
        }
        guard let cell = collectionView.cellForItem(at: IndexPath(row:0,section: 2)) as? EmojiCells,
              let emoji = cell.getEmoji() else {print("Unable to get emoji");return nil}
        selectedEmoji = emoji
        return emoji
    }
}

extension CreateEventVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextField", for: indexPath) as? TrackNameCell else {return UICollectionViewCell()}
            cell.textFieldDelegate = self
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as? EventCell else {return UICollectionViewCell()}
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCells", for: indexPath) as? EmojiCells else {print(2131231); return UICollectionViewCell()}
            cell.delegate = self
            cell.setupView()
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCells", for: indexPath) as? ColorCells else {print(2131231); return UICollectionViewCell()}
            cell.delegate = self
            cell.setupView()
            return cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateCancelButtons", for: indexPath) as? CreateCancelButtonsCells else {print(2131231); return UICollectionViewCell()}
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

extension CreateEventVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1{
            return CGSize(width: collectionView.bounds.width, height: 75)
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
            return view
        }else if indexPath.section == 3{
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SupplementaryView else {return UICollectionReusableView()}
            view.titleLabel.text = "Цвет"
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

//extension CreateEventVC: TrackNameCellDelegateProtocol{
//    func updateCreateButtonState(isEnabled: Bool){
//        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 4)) as? CreateCancelButtonsCells else {
//            print("[updateCreateButtonState] CreateEventVC unable to get cell")
//            return
//        }
//        cell.updateCreateButtonState(isEnabled: isEnabled)
//    }
//    func textFieldDidChange(text: String) {
//        if !(text.isEmpty){
//            updateCreateButtonState(isEnabled: true)
//        }else{
//            updateCreateButtonState(isEnabled: false)
//        }
//    }
//}

extension CreateEventVC: TrackNameCellDelegateProtocol{
    func updateCreateButtonState(isEnabled: Bool){
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 4)) as? CreateCancelButtonsCells else {
            return}
        cell.updateCreateButtonState(isEnabled: isEnabled)
    }
    func textFieldDidChange(text: String) {
        updateButtonEnabling()
    }
}

extension CreateEventVC: EmojiCellsDelegateProtocol{
    func emojiWasChosen() {
        updateButtonEnabling()
    }
    
    func emojiWasUnchosen() {
        updateButtonEnabling()
    }
}

extension CreateEventVC: ColorCellsDelegateProtocol{
    func colorWasChosen() {
        updateButtonEnabling()
    }
    func colorWasUnchosen() {
        updateButtonEnabling()
    }
}

extension CreateEventVC{
    func updateButtonEnabling(){
        if (getName() != nil) &&  (getEmoji() != nil) && (getColor() != nil){
            updateCreateButtonState(isEnabled: true)
        }else{
            updateCreateButtonState(isEnabled: false)
        }
    }
}


extension CreateEventVC: CreateCancelButtonsDelegateProtocol{
    func createButtonTappedDelegate(){
        let timetable: [WeekDay] = [.monday,.tuesday,.wednesday,.thursday,.friday,.saturday,.sunday]
        guard let name = getName(),
              let color = getColor(),
              let emoji = getEmoji() else {return}
        let createdAt = Date()
        let id = UUID()
        let type = TrackerType.single
        let tracker = Tracker(id: id, type: type, name: name, emoji: emoji, color: color, createdAt: createdAt, timetable: timetable)
        let categoryName = "Какашка"
        delegate?.addNewTracker(tracker: tracker, categoryName: categoryName)
        dismiss(animated: true)
    }
    
    func cancelButtonTappedDelegate(){
        dismiss(animated: true)
    }
}
