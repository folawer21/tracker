//
//  EmojiCells.swift
//  tracker
//
//  Created by Александр  Сухинин on 31.05.2024.
//

import UIKit

final class EmojiCell: UICollectionViewCell{
    let emoji: UILabel = UILabel()
    let emojiBlock: UIView = UIView()
    func setupView(text: String){
        contentView.addSubview(emojiBlock)
        emojiBlock.addSubview(emoji)
        
        emojiBlock.translatesAutoresizingMaskIntoConstraints = false
        emoji.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiBlock.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiBlock.topAnchor.constraint(equalTo: contentView.topAnchor),
            emojiBlock.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            emojiBlock.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emoji.leadingAnchor.constraint(equalTo: emojiBlock.leadingAnchor),
            emoji.topAnchor.constraint(equalTo: emojiBlock.topAnchor),
            emoji.bottomAnchor.constraint(equalTo: emojiBlock.bottomAnchor),
            emoji.trailingAnchor.constraint(equalTo: emojiBlock.trailingAnchor),
            
        ])
        emoji.text = text
        
        emojiBlock.backgroundColor = UIColor(named: "EmojiBlock")
        emojiBlock.layer.cornerRadius = 16
        hideBlock()
    }
    
    func showBlock(){
        emojiBlock.isHidden = false
    }
    
    func hideBlock(){
        emojiBlock.isHidden = true
    }
}

final class EmojiCells: UICollectionViewCell{
    
    let emojes = ["🙂","😻","🌺","🐶","❤️","😱","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝","😪"]

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    func setupView(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .white
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "emoji")
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension EmojiCells:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emoji", for: indexPath) as? EmojiCell else {return UICollectionViewCell()}
        cell.setupView(text: emojes[indexPath.row])
        return cell
    }
    
}

extension EmojiCells: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else {return}
        cell.showBlock()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else {return}
        cell.hideBlock()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
