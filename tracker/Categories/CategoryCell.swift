//
//  CategoryCell.swift
//  tracker
//
//  Created by Александр  Сухинин on 13.07.2024.
//

import UIKit

final class CategoryCell: UITableViewCell{
    static let cellIdentifier = "CategoryCell"
    let categoryNameLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    let cellView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "greyForCollection")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        return view
    }()
    
    var isChosen: Bool = false
    
    let chosenImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        imageView.image = UIImage(named: "categoryChosenButton")
        return imageView
    }()
    
    func makeChosen(){
        isChosen = true
        chosenImageView.isHidden = false
    }
    
    func makeUnChosen(){
        isChosen = false
        chosenImageView.isHidden = true
    }
    func setCategoryNameTitle(name: String){
        categoryNameLabel.text = name
    }
    
    func setupCell(name: String){
        contentView.backgroundColor = .white
        setCategoryNameTitle(name: name)
        contentView.addSubview(cellView)
        cellView.addSubview(categoryNameLabel)
        cellView.addSubview(chosenImageView)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -5),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            chosenImageView.widthAnchor.constraint(equalToConstant: 24),
            chosenImageView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            chosenImageView.heightAnchor.constraint(equalToConstant: 24),
            chosenImageView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16),
            chosenImageView.leadingAnchor.constraint(equalTo: categoryNameLabel.trailingAnchor),
            categoryNameLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            categoryNameLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -26),
            categoryNameLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 27),
            categoryNameLabel.trailingAnchor.constraint(equalTo: chosenImageView.leadingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        isChosen = false
        chosenImageView.isHidden = true
    }
}
