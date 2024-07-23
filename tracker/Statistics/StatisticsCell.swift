//
//  StatisticsCell.swift
//  tracker
//
//  Created by Александр  Сухинин on 23.07.2024.
//

import UIKit

final class StatisticsCell: UITableViewCell {
    static let reuseIdentifier = "StatisticsCellReuseIdentifier"
    let numberLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 34)
        label.textColor = Colors.addButtonColor
        label.backgroundColor = Colors.blackBackgroundColor
        label.textAlignment = .left
        return label
    }()
    
    let statisticLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = Colors.addButtonColor
        label.backgroundColor = Colors.blackBackgroundColor
        label.textAlignment = .left
        return label
    }()
    
    func setupCell(number: Int, text: String) {
        contentView.addSubview(numberLabel)
        contentView.addSubview(statisticLabel)
        contentView.backgroundColor = Colors.blackBackgroundColor
        contentView.layer.borderWidth = 1
        
        contentView.layer.cornerRadius = 16
        numberLabel.text = "\(number)"
        statisticLabel.text = text
   
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            numberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            numberLabel.bottomAnchor.constraint(equalTo: statisticLabel.topAnchor, constant: -7),
//            numberLabel.heightAnchor.constraint(equalToConstant: 41),
//            
//            statisticLabel.heightAnchor.constraint(equalToConstant: 18),
            statisticLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            statisticLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            statisticLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            statisticLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 7)
        ])
        
        
    }
    
    
    
}
