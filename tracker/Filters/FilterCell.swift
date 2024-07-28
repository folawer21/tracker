//
//  FilterCell.swift
//  tracker
//
//  Created by Александр  Сухинин on 25.07.2024.
//

import UIKit

final class FilterCell: UITableViewCell {
    var isChosen: Bool = false
    private let imageName = "categoryChosenButton"
    private let filterNameLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.addButtonColor
        label.backgroundColor = .clear
        return label
    }()
    private let chosenImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = Colors.createHabbitEventSecondaryColor
        return imageView
    }()
    func setupCell(isChosen: Bool, filterName: String) {
        self.isChosen = isChosen
        filterNameLabel.text = filterName
        chosenImageView.isHidden = isChosen ? false : true
        chosenImageView.image = UIImage(named: imageName)
        contentView.backgroundColor = Colors.createHabbitEventSecondaryColor
        contentView.addSubview(filterNameLabel)
        contentView.addSubview(chosenImageView)
        NSLayoutConstraint.activate([
            chosenImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chosenImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chosenImageView.heightAnchor.constraint(equalToConstant: 24),
            chosenImageView.widthAnchor.constraint(equalToConstant: 24),
            chosenImageView.leadingAnchor.constraint(equalTo: filterNameLabel.trailingAnchor, constant: 1),
            filterNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            filterNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -26),
            filterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            filterNameLabel.trailingAnchor.constraint(equalTo: chosenImageView.leadingAnchor, constant: -1)
        ])
    }
    func showChosenImage() {
        isChosen = true
        chosenImageView.isHidden = false
    }
    func hideChosenImage() {
        isChosen = false
        chosenImageView.isHidden = true
    }
    override func prepareForReuse() {
        hideChosenImage()
    }
}
