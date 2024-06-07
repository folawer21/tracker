//
//  EmojiCells.swift
//  tracker
//
//  Created by Александр  Сухинин on 31.05.2024.
//

import UIKit

protocol EmojiCellsDelegateProtocol: AnyObject{
    func emojiWasChosen()
    func emojiWasUnchosen()
}

final class EmojiCell: UICollectionViewCell{
    let emoji: UILabel = UILabel()
    func setupView(text: String){
        contentView.addSubview(emoji)
        emoji.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emoji.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emoji.heightAnchor.constraint(equalToConstant: 52),
            emoji.widthAnchor.constraint(equalToConstant: 52)
        ])
        emoji.text = text
        emoji.textAlignment = .center
        emoji.font = .boldSystemFont(ofSize: 32)
        emoji.backgroundColor = .white
        emoji.layer.cornerRadius = 16
        emoji.layer.masksToBounds = true
        hideBlock()
    }
    
    func showBlock(){
        emoji.backgroundColor = UIColor(named: "EmojiBlock")
    }
    
    func hideBlock(){
        emoji.backgroundColor = .white
    }
}

final class EmojiCells: UICollectionViewCell{
    let emojes = ["🙂","😻","🌺","🐶","❤️","😱","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝","😪"]
    private var selectedEmoji: String?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    weak var delegate: EmojiCellsDelegateProtocol?
    func setupView(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .white
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "emoji")
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor,constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -24)
        ])
    }
    func getEmoji() -> String?{
        return selectedEmoji
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
        selectedEmoji = cell.emoji.text
        cell.showBlock()
        delegate?.emojiWasChosen()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else {return}
        selectedEmoji = nil
        cell.hideBlock()
        delegate?.emojiWasUnchosen()
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

