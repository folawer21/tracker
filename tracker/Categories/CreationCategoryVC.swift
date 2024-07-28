//
//  CreationCategoryVC.swift
//  tracker
//
//  Created by Александр  Сухинин on 13.07.2024.
//

import UIKit

final class CreationCategoryVC: UIViewController {
    weak var viewModel: CategoriesViewModel?
    private let nameInput = {
        let field = UITextField()
        let inputName = NSLocalizedString("creation_categoty_field", comment: "")
        field.placeholder = inputName
        field.backgroundColor = Colors.createHabbitEventSecondaryColor
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 16
        field.indent(size: 16)
        return field
    }()
    private let completeButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "greyForCollection")
        let buttonText = NSLocalizedString("creation_categoty_button", comment: "")
        button.isEnabled = false
        button.setTitle(buttonText, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.setTitleColor(Colors.blackBackgroundColor, for: .normal)
        button.backgroundColor = .ypGray
        return button
    }()
    init(viewModel: CategoriesViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel?.onCreationAllowedStateChange = { [weak self ] isCreationAllowed in
            self?.setCompleteButton(enabled: isCreationAllowed)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setCompleteButton(enabled: Bool) {
        completeButton.isEnabled = enabled
        completeButton.backgroundColor = completeButton.isEnabled ? Colors.addButtonColor : .ypGray
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationTitleText = NSLocalizedString("creation_categoty_navtitle", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.title = navigationTitleText
        view.backgroundColor = Colors.blackBackgroundColor
        view.addSubview(nameInput)
        view.addSubview(completeButton)
        NSLayoutConstraint.activate([
            nameInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameInput.heightAnchor.constraint(equalToConstant: 75),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            completeButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        nameInput.delegate = self
        nameInput.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }

    @objc func completeButtonTapped() {
        guard let name = nameInput.text else {return}
        viewModel?.createNewCategory(categoryName: name)
        navigationController?.popViewController(animated: true)
    }
}

extension CreationCategoryVC: UITextFieldDelegate {
    @objc private func textFieldDidChange() {
        viewModel?.textFieldDidChange(categoryName: nameInput.text ?? "")
    }
}
