//
//  CreateCancelButtons.swift
//  tracker
//
//  Created by Александр  Сухинин on 31.05.2024.
//

import UIKit

protocol CreateCancelButtonsDelegateProtocol: AnyObject {
    func createButtonTappedDelegate()
    func cancelButtonTappedDelegate()
    func editButtonTappedDelegate()
}

final class CreateCancelButtonsCells: UICollectionViewCell {
    let createButton = UIButton()
    let cancelButton = UIButton()
    var isEditing: Bool = false
    weak var delegate: CreateCancelButtonsDelegateProtocol?

    func setupView( ){
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

    func configCreateButton( ){
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.setTitleColor(Colors.createButtonTextColorEnabled, for: .normal)
        createButton.setTitleColor(Colors.createButtonTextColorDisabled, for: .disabled)
        createButton.isEnabled = false
        createButton.backgroundColor = createButton.isEnabled ? Colors.createButtonColor : .ypGray
        if isEditing {
            let buttonText = NSLocalizedString("save_button", comment: "")
            createButton.setTitle(buttonText, for: .normal)
            createButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        } else {
            let buttonText = NSLocalizedString("createcancel_button_create", comment: "")
            createButton.setTitle(buttonText, for: .normal)
            createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        }

    }

    func makeEditingScreen( ){
        createButton.titleLabel?.text = NSLocalizedString("save_button", comment: "")
        createButton.removeTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    func configCancelButton( ){
        cancelButton.backgroundColor = Colors.blackBackgroundColor
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius = 16
        let buttonText = NSLocalizedString("createcancel_button_cancel", comment: "")
        cancelButton.setTitle(buttonText, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = Colors.cancelButtonTextAndBorder?.cgColor
        cancelButton.setTitleColor(Colors.cancelButtonTextAndBorder, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }

    @objc func createButtonTapped( ){
        delegate?.createButtonTappedDelegate()
    }

    @objc func cancelButtonTapped( ){
        delegate?.cancelButtonTappedDelegate()
    }

    @objc func editButtonTapped( ){
        delegate?.editButtonTappedDelegate()
    }

    func updateCreateButtonState(isEnabled: Bool ){
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? Colors.createButtonColor : .ypGray
    }
}
