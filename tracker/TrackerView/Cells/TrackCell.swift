//
//  TrackCell.swift
//  tracker
//
//  Created by Александр  Сухинин on 29.05.2024.
//
//
import UIKit

//enum ButtonStates{
//    case doneToday
//    case singleDone
//    case unavailibleDateLateer
//    case availible
//}

protocol TrackCellDelegateProtocol: AnyObject{
    func deleteTrackerRecord(id: UUID)
    func addTrackerRecord(id: UUID)
//    func buttonTapped(id:UUID)
}

final class TrackCell: UICollectionViewCell{
    //Цветной блок
    private let colorBlock = UIView()
    private let emodji = UILabel()
    private let emodjiBlock = UIView()
    private let nameLabel = UILabel()

    //Белый блок
    private let infoBlock = UIView()
//    var daysCount: Int = 0
    let daysLabel = UILabel()
    let plusButton = UIButton()
    var buttonWasTapped = false
    var trackerId: UUID?
    private let plusImage = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
    private let doneImage = UIImage(named: "Done")?.withRenderingMode(.alwaysTemplate)
    

    weak var delegate: TrackCellDelegateProtocol?
    
    func configCell(track: Tracker,days: Int,isDone:Bool,availible:Bool){
        trackerId = track.id
        emodji.text = track.emoji
        nameLabel.text = track.name
//        daysLabel.text = "0 дней"
        colorBlock.backgroundColor = track.color
        plusButton.tintColor = track.color
        configScreen()
        if track.type == .habbit{
            configStateHabbit(isDone: isDone, availible: availible)
        }
        if track.type == .single{
            configStateSingle(isDone: isDone, availible: availible)
        }
        changeText(daysCount: days)
    }
    
    private func configStateHabbit(isDone:Bool,availible:Bool){
        plusButton.layer.opacity = 1
        if isDone{
            buttonWasTapped = true
            plusButton.isSelected = true
            plusButton.layer.opacity = 0.3
            enableButton()
        }else{
            if availible{
                buttonWasTapped = false
                plusButton.isSelected = false
                enableButton()
            }else{
                buttonWasTapped = false
                plusButton.isSelected = false
                plusButton.layer.opacity = 0.3
                disableButton()
            }
        }
    }
    
    private func configStateSingle(isDone:Bool,availible:Bool){
        plusButton.layer.opacity = 1
        
        print(isDone,availible)
        
        
        if isDone && availible{
            print(1)
            buttonWasTapped = true
            plusButton.isSelected = true
            plusButton.layer.opacity = 0.3
            enableButton()
        }
        if isDone && !availible{
            print(2)

            buttonWasTapped = true
            plusButton.isSelected = true
            plusButton.layer.opacity = 0.3
            disableButton()
            plusButton.imageView?.image = doneImage
        }
        if !isDone && availible{
            print(3)
            buttonWasTapped = false
            plusButton.isSelected = false
            enableButton()
        }
        if !isDone && !availible{
            print(4)
            buttonWasTapped = false
            plusButton.isSelected = false
            plusButton.layer.opacity = 0.3
            disableButton()
        }
    }

  
    
    private func changeText(daysCount: Int){
        let flag = daysCount % 10
        switch flag{
        case 1:
            daysLabel.text = "\(daysCount) день"
        case 2,3,4:
            daysLabel.text = "\(daysCount) дня"
        default:
            daysLabel.text = "\(daysCount) дней"
        }
    }
    
    
    
    
//    func buttonAlreadyTapped(){
//        plusButton.layer.opacity = 0.3
//        plusButton.isSelected = true
//        buttonWasTapped = true
//    }
//    func buttonDidntTapped(){
//        buttonWasTapped = false
//        plusButton.isSelected = false
//        plusButton.layer.opacity = 1
//    }
//    
    func enableButton(){
        plusButton.isEnabled = true
    }
    
    func disableButton(){
        plusButton.isEnabled = false
    }
   
    
    @objc func buttonTapped(){
//        if buttonWasTapped{
//            daysCount -= 1
//            changeText()
//            plusButton.isSelected = false
//            buttonWasTapped = false
//            plusButton.layer.opacity = 1
//            guard let id = tracker?.id else {
//                print("[buttonTapped] TrackCell - unable to get Id ")
//                return
//            }
//            delegate?.deleteTrackerRecord(id: id)
//        }else{
//            daysCount += 1
//            changeText()
//            plusButton.isSelected = true
//            plusButton.layer.opacity = 0.3
//            buttonWasTapped = true
//            guard let id = tracker?.id else {
//                print("[buttonTapped] TrackCell - unable to get Id ")
//                return
//            }
//            delegate?.addTrackerRecord(id: id)
//        }
        guard let id = trackerId else {return}
        if buttonWasTapped{
            delegate?.deleteTrackerRecord(id: id)
        }else{
            delegate?.addTrackerRecord(id: id)
        }
        
    }
}

extension TrackCell{
    func configScreen(){
        addSubViews()
        applyConstraints()
        configButton()
        translateToFalse()
        emodjiBlock.backgroundColor = .white.withAlphaComponent(0.3)
        emodjiBlock.layer.cornerRadius = 12
        emodjiBlock.layer.masksToBounds = true
        colorBlock.layer.cornerRadius = 16
        infoBlock.backgroundColor = .white
        daysLabel.numberOfLines = 2
        daysLabel.textColor = .black
        daysLabel.font = .systemFont(ofSize: 12)
        nameLabel.textColor = .white
        emodji.font =  UIFont.systemFont(ofSize: 14)
        emodji.textAlignment = .center
    }
    
    func translateToFalse(){
        colorBlock.translatesAutoresizingMaskIntoConstraints = false
        emodji.translatesAutoresizingMaskIntoConstraints = false
        emodjiBlock.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        infoBlock.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubViews(){
        contentView.addSubview(colorBlock)
        contentView.addSubview(infoBlock)
        colorBlock.addSubview(emodjiBlock)
        colorBlock.addSubview(nameLabel)
        infoBlock.addSubview(daysLabel)
        infoBlock.addSubview(plusButton)
        emodjiBlock.addSubview(emodji)
    }
    
    func applyConstraints(){
        NSLayoutConstraint.activate([
            colorBlock.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorBlock.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorBlock.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorBlock.bottomAnchor.constraint(equalTo: infoBlock.topAnchor),
            infoBlock.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoBlock.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoBlock.topAnchor.constraint(equalTo: colorBlock.bottomAnchor),
            infoBlock.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            emodjiBlock.leadingAnchor.constraint(equalTo: colorBlock.leadingAnchor, constant: 12),
            emodjiBlock.topAnchor.constraint(equalTo: colorBlock.topAnchor, constant: 12),
            emodjiBlock.heightAnchor.constraint(equalToConstant: 24),
            emodjiBlock.widthAnchor.constraint(equalToConstant: 24),
            
            emodji.centerXAnchor.constraint(equalTo: emodjiBlock.centerXAnchor),
            emodji.centerYAnchor.constraint(equalTo: emodjiBlock.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: colorBlock.leadingAnchor, constant: 12),
            nameLabel.bottomAnchor.constraint(equalTo: colorBlock.bottomAnchor, constant: -12),
            nameLabel.trailingAnchor.constraint(equalTo: colorBlock.trailingAnchor, constant: -12),
            nameLabel.topAnchor.constraint(equalTo: emodjiBlock.bottomAnchor, constant: 8),
            
            daysLabel.leadingAnchor.constraint(equalTo: infoBlock.leadingAnchor, constant: 12),
            daysLabel.bottomAnchor.constraint(equalTo: infoBlock.bottomAnchor, constant: -24),
            daysLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            daysLabel.topAnchor.constraint(equalTo: infoBlock.topAnchor, constant: 16),
            
            plusButton.leadingAnchor.constraint(equalTo: daysLabel.trailingAnchor, constant: 8),
            plusButton.topAnchor.constraint(equalTo: infoBlock.topAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: infoBlock.trailingAnchor,constant: -12),
            plusButton.bottomAnchor.constraint(equalTo: infoBlock.bottomAnchor, constant: -16),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    func configButton(){
        plusButton.setImage(plusImage, for: .normal)
        plusButton.setImage(doneImage, for: .selected)
        plusButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
}
