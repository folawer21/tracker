//
//  StatisticsCell.swift
//  tracker
//
//  Created by Александр  Сухинин on 23.07.2024.
//

import UIKit

final class StatisticsCell: UITableViewCell {
    static let reuseIdentifier = "StatisticsCellReuseIdentifier"
    let gradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        return view
    }()
    let blockView = {
        let view = UIView()
        view.backgroundColor = Colors.blackBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        return view
    }()
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
        gradientView.backgroundColor = Colors.blackBackgroundColor
        contentView.addSubview(gradientView)
        gradientView.addSubview(blockView)
        blockView.addSubview(numberLabel)
        blockView.addSubview(statisticLabel)
        contentView.backgroundColor = Colors.blackBackgroundColor
        contentView.layer.cornerRadius = 16
        numberLabel.text = "\(number)"
        statisticLabel.text = text
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            blockView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 1),
            blockView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 1),
            blockView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -1),
            blockView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -1),
            numberLabel.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 12),
            numberLabel.topAnchor.constraint(equalTo: blockView.topAnchor, constant: 12),
            numberLabel.trailingAnchor.constraint(equalTo: blockView.trailingAnchor, constant: -12),
            numberLabel.bottomAnchor.constraint(equalTo: statisticLabel.topAnchor, constant: -7),
            statisticLabel.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 12),
            statisticLabel.trailingAnchor.constraint(equalTo: blockView.trailingAnchor, constant: -12),
            statisticLabel.bottomAnchor.constraint(equalTo: blockView.bottomAnchor, constant: -12),
            statisticLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 7)
        ])
    }
}
