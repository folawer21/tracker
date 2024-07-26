//
//  ColorCells.swift
//  tracker
//
//  Created by Александр  Сухинин on 31.05.2024.
//

import UIKit

protocol ColorCellsDelegateProtocol: AnyObject{
    func colorWasChosen()
    func colorWasUnchosen()
}

final class ColorCell: UICollectionViewCell{
    let color: UIView = UIView()
    func setupView(cellColor: UIColor){
        contentView.addSubview(color)
        
        color.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            color.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            color.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            color.heightAnchor.constraint(equalToConstant: 40),
            color.widthAnchor.constraint(equalToConstant: 40)
        ])
        color.backgroundColor = cellColor
        color.layer.cornerRadius = 8
        color.layer.masksToBounds = true
        contentView.layer.borderWidth = 3
        contentView.layer.cornerRadius = 8
        hideBlock()
    }
    
    func showBlock(){
        contentView.layer.borderColor = color.backgroundColor?.withAlphaComponent(0.3).cgColor
    }
    
    func hideBlock(){
        contentView.layer.borderColor = Colors.blackBackgroundColor.cgColor
    }
}

final class ColorCells: UICollectionViewCell{
    
    let colores: [UIColor] = [
        .cellSection1, .cellSection2,
        .cellSection3, .cellSection4,
        .cellSection5, .cellSection6,
        .cellSection7, .cellSection8,
        .cellSection9, .cellSection10,
        .cellSection11, .cellSection12,
        .cellSection13, .cellSection14,
        .cellSection15, .cellSection16,
        .cellSection17, .cellSection18
    ]
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var selectedColor: UIColor?
    weak var delegate: ColorCellsDelegateProtocol?
    func setupView(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = Colors.blackBackgroundColor
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "color")
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor,constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -24)
        ])
    }
    func getColor() -> UIColor?{
        return selectedColor
    }
}

extension ColorCells:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "color", for: indexPath) as? ColorCell else {return UICollectionViewCell()}
        let color = colores[indexPath.row]
        if let selectedColor = selectedColor {
            if UIColorMarshalling.shared.hexString(from: color)  == UIColorMarshalling.shared.hexString(from: selectedColor) {
                cell.setupView(cellColor: color)
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                cell.isSelected = true
                cell.showBlock()
                return cell
            } else {
                cell.setupView(cellColor: color )
                return cell
            }
        }
        cell.setupView(cellColor: color )
        return cell
    }
    
}

extension ColorCells: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else {return}
        selectedColor = cell.color.backgroundColor
        delegate?.colorWasChosen()
        cell.showBlock()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else {return}
        selectedColor = nil
        delegate?.colorWasUnchosen()
        cell.hideBlock()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        CGFloat.zero
    }
}
