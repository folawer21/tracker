//
//  CreationCategoryVC.swift
//  tracker
//
//  Created by Александр  Сухинин on 13.07.2024.
//

import UIKit

final class CreationCategoryVC: UIViewController{
    weak var viewModel: CategoriesViewModel?
    
    let nameInput = {
        let field = UITextField()
        field.placeholder = "Введите название категории"
        field.backgroundColor = UIColor(named: "greyForCollection")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 16
        field.indent(size: 16)
        return field
    }()
    
    let completeButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "greyForCollection")
        button.isUserInteractionEnabled = false
        button.setTitle("Готово", for: .normal)
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
    
    private func setCompleteButton(enabled: Bool){
        completeButton.isUserInteractionEnabled = enabled
        completeButton.backgroundColor = enabled ? .black : .lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.title = "Новая категория"
        view.backgroundColor = .white
        
        view.addSubview(nameInput)
        view.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            nameInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 24),
            nameInput.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
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
    
    @objc func completeButtonTapped(){
        guard let name = nameInput.text else {return}
        viewModel?.createNewCategory(categoryName: name)
        navigationController?.popViewController(animated: true)
    }
}

extension CreationCategoryVC: UITextFieldDelegate{
    @objc private func textFieldDidChange(){
        viewModel?.textFieldDidChange(categoryName: nameInput.text ?? "")
    }
}
