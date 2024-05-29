//
//  TrackCell.swift
//  tracker
//
//  Created by Александр  Сухинин on 29.05.2024.
//

import UIKit

final class TrackCell: UICollectionViewCell{
    //Цветной блок
    let colorBlock = UIView(frame: CGRect(x: 0, y: 0, width: 167, height: 90))
    let emodji = UILabel()
    let emodjiBlock = UIView()
    let nameLabel = UILabel()

    
    //Белый блок
    let infoBlock = UIView(frame: CGRect(x: 0, y: 0, width: 167, height: 58))
    var daysCount: Int = 0
    let daysLabel = UILabel()
    let plusButton = UIButton()
    var buttonWasTapped = false
    
    func configCell(track: Tracker){
        emodji.text = track.emoji
        nameLabel.text = track.name
        daysLabel.text = "0 дней"
        colorBlock.backgroundColor = track.color
        plusButton.backgroundColor = track.color
        configScreen()
       
    }
    func configScreen(){
        addSubViews()
        applyConstraints()
        configButton()
        emodjiBlock.backgroundColor = .white
        emodjiBlock.layer.opacity = 30
        emodjiBlock.layer.cornerRadius = 68
        
        colorBlock.layer.cornerRadius = 16
        infoBlock.backgroundColor = .white
        
        daysLabel.numberOfLines = 2
        daysLabel.textColor = .white
        daysLabel.font = .systemFont(ofSize: 12)
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
            emodjiBlock.bottomAnchor.constraint(equalTo: nameLabel.topAnchor,constant: -8),
            
            emodji.centerXAnchor.constraint(equalTo: emodjiBlock.centerXAnchor),
            emodji.centerYAnchor.constraint(equalTo: emodjiBlock.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: colorBlock.leadingAnchor, constant: 12),
            nameLabel.bottomAnchor.constraint(equalTo: colorBlock.bottomAnchor, constant: -12),
            nameLabel.trailingAnchor.constraint(equalTo: colorBlock.trailingAnchor, constant: -12),
            nameLabel.topAnchor.constraint(equalTo: emodjiBlock.bottomAnchor, constant: 8),
            
            daysLabel.leadingAnchor.constraint(equalTo: infoBlock.leadingAnchor, constant: 12),
            daysLabel.bottomAnchor.constraint(equalTo: infoBlock.bottomAnchor, constant: -24),
            daysLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            daysLabel.topAnchor.constraint(equalTo: infoBlock.topAnchor, constant: 16)
            
            
            
        
        
        ])
    }
    
    func configButton(){
        plusButton.setImage(UIImage(named: "plus"), for: .normal)
        plusButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    
    
    private func changeText(){
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
    
    func disableButton(){
        plusButton.isEnabled = false
    }
    func enableButton(){
        plusButton.isEnabled = true
    }
    @objc func buttonTapped(){
        if buttonWasTapped{
            daysCount -= 1
            changeText()
            plusButton.setImage(UIImage(named: "plus"), for: .normal)
            plusButton.layer.opacity = 100
        }else{
            daysCount += 1
            changeText()
            plusButton.setImage(UIImage(named: "Done"), for: .normal)
            plusButton.layer.opacity = 30
        }
    }
}
