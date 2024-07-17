//
//  CreateCancelButtons.swift
//  tracker
//
//  Created by Александр  Сухинин on 31.05.2024.
//

import UIKit

protocol CreateCancelButtonsDelegateProtocol: AnyObject{
    func createButtonTappedDelegate()
    func cancelButtonTappedDelegate()
}

final class CreateCancelButtonsCells: UICollectionViewCell{
    let createButton = UIButton()
    let cancelButton = UIButton()
    
    weak var delegate: CreateCancelButtonsDelegateProtocol?
    
    func setupView(){
        contentView.addSubview(cancelButton)
        contentView.addSubview(createButton)
        configCancelButton()
        configCreateButton()
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 161)
        ])
    }
    
    func configCreateButton(){
        createButton.backgroundColor = .ypGray
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.setTitleColor(.white, for: .normal)
        let buttonText = NSLocalizedString("createcancel_button_create", comment: "")
        createButton.setTitle(buttonText, for: .normal)
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    func configCancelButton(){
        cancelButton.backgroundColor = .white
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius = 16
        let buttonText = NSLocalizedString("createcancel_button_cancel", comment: "")
        cancelButton.setTitle(buttonText, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(named: "RedForBottoms")?.cgColor
        cancelButton.setTitleColor(UIColor(named: "RedForBottoms"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    @objc func createButtonTapped(){
        delegate?.createButtonTappedDelegate()
    }
    
    @objc func cancelButtonTapped(){
        delegate?.cancelButtonTappedDelegate()
    }
    
    func updateCreateButtonState(isEnabled: Bool){
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? .black : .ypGray
    }
}
