//
//  CreateHabbitVC.swift
//  tracker
//
//  Created by Александр  Сухинин on 29.05.2024.
//

import UIKit
protocol CreateHabbitDelegateProtocol: AnyObject{
    func addNewTracker(tracker: Tracker,categoryName : String)
}
final class CreateHabbitVC: UIViewController{
    let cancelButton = UIButton()
    let createButton = UIButton()
    weak var delegate: CreateHabbitDelegateProtocol?
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
        collectionView.register(ButtonCells.self, forCellWithReuseIdentifier: "ButtonCell")
        collectionView.register(EmojiCells.self, forCellWithReuseIdentifier: "EmojiCells")
        collectionView.register(ColorCells.self, forCellWithReuseIdentifier: "ColorCells")
        collectionView.register(CreateCancelButtonsCells.self, forCellWithReuseIdentifier: "CreateCancelButtons")
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    private func getEnumTimetable(arr: [String]?) -> [WeekDay]?{
        var result: [WeekDay] = []
        guard let arr = arr else {return nil}
        for i in 0..<arr.count{
            guard let day = WeekDay(rawValue: arr[i]) else { break}
            result.append(day)
        }
        return result
    }
    
    private func getTimetable() -> [WeekDay]?{
        guard let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 1)) as? ButtonCells else {return nil}
        let days = cell.daysArr
        let enumDays = getEnumTimetable(arr: days)
        return enumDays
    }
    
    private func getName() -> String?{
        guard let cell = collectionView.cellForItem(at: IndexPath(row:0,section: 0)) as? TrackNameCell else {return nil}
        guard let name = cell.getName() else {return nil}
        return name
    }
    
}

extension CreateHabbitVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextField", for: indexPath) as? TrackNameCell else {return UICollectionViewCell()}
            cell.textFieldDelegate = self
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as? ButtonCells else {return UICollectionViewCell()}
            cell.delegate = self
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCells", for: indexPath) as? EmojiCells else {print(2131231); return UICollectionViewCell()}
            cell.setupView()
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCells", for: indexPath) as? ColorCells else {print(2131231); return UICollectionViewCell()}
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
            return CGSize(width: collectionView.frame.width, height: 18) // Замените на ваш желаемый размер
            
        }else{
            return CGSize.zero
        }
    }
}

extension CreateHabbitVC:ButtonCellDelegateProtocol{
    func showTimeTable(vc: TimeTableVC){
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CreateHabbitVC: TrackNameCellDelegateProtocol{
    func updateCreateButtonState(isEnabled: Bool){
        //TODO: здесь добавить счетчик если 4 то разрешать нажатие пока ток по тексту
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 4)) as? CreateCancelButtonsCells else {
            print("[updateCreateButtonState] CreateHabbitVC unable to get cell")
            return
        }
        cell.updateCreateButtonState(isEnabled: isEnabled)
    }
    func textFieldDidChange(text: String) {
        updateCreateButtonState(isEnabled: !text.isEmpty)
    }
}

extension CreateHabbitVC: CreateCancelButtonsDelegateProtocol{
    func createButtonTappedDelegate(){
        guard let timetable = getTimetable() else {return}
        guard let name = getName() else {return}
        let createdAt = Date()
        let id = UUID()
        let emoji = "💩"
        let color = UIColor.green
        let type = TrackerType.habbit
        
        let tracker = Tracker(id: id, type: type, name: name, emoji: emoji, color: color, createdAt: createdAt, timetable: timetable)
        let categoryName = "Какашки"
        delegate?.addNewTracker(tracker: tracker, categoryName: categoryName)
        dismiss(animated: true)
    }
    
    func cancelButtonTappedDelegate(){
        dismiss(animated: true)
    }
}
