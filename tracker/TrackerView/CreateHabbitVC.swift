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
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        cancelButton.backgroundColor = .white
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius = 16
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(named: "RedForBottoms")?.cgColor
        cancelButton.setTitleColor(UIColor(named: "RedForBottoms"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        createButton.backgroundColor = .ypGray
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.setTitleColor(.white, for: .normal)
        createButton.setTitle("Создать", for: .normal)
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor,constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor,constant: -16),
            
            cancelButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 161)
            
        
        ])
        
        collectionView.register(TrackNameCell.self, forCellWithReuseIdentifier: "TextField")
        collectionView.register(ButtonCells.self, forCellWithReuseIdentifier: "ButtonCell")
    }
    
    @objc private func createButtonTapped(){
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
    
    @objc private func cancelButtonTapped(){
        dismiss(animated: true)
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
//            cell.backgroundColor = UIColor(named: "TextFieldColor")
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

extension CreateHabbitVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1{
            return CGSize(width: collectionView.bounds.width, height: 150)
        }else{
            return CGSize(width: collectionView.bounds.width, height: 75)

        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         if section == 1{
            let sectionInsets = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
            return sectionInsets
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

extension CreateHabbitVC:ButtonCellDelegateProtocol{
    func showTimeTable(vc: TimeTableVC){
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension CreateHabbitVC: TrackNameCellDelegateProtocol{
    func updateCreateButtonState(isEnabled: Bool){
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? .black : .ypGray
    }

    
    func textFieldDidChange(text: String) {
        updateCreateButtonState(isEnabled: !text.isEmpty)
    }
}

