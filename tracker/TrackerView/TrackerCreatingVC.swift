//
//  TrackerCreatingVC.swift
//  tracker
//
//  Created by Александр  Сухинин on 29.05.2024.
//

import UIKit

protocol TrackerCreatingDelegateProtocol: AnyObject{
    func addNewTracker(tracker: Tracker, categoryName: String)
}

final class TrackerCreatingVC: UIViewController{
    let habbitButton: UIButton = UIButton()
    let eventButton: UIButton = UIButton()
    weak var delegate: TrackerCreatingDelegateProtocol?
    
    private func configHabbitButton(){
        habbitButton.backgroundColor = .black
        habbitButton.tintColor = .white
        habbitButton.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight(510))
        habbitButton.setTitle("Привычка", for: .normal)
        habbitButton.layer.cornerRadius = 16
        habbitButton.addTarget(self, action: #selector(showHabbitView), for: .touchUpInside)
        habbitButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configEventButton(){
        eventButton.backgroundColor = .black
        eventButton.tintColor = .white
        eventButton.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight(510))
        eventButton.setTitle("Нерегулярное событие", for: .normal)
        eventButton.layer.cornerRadius = 16
        eventButton.addTarget(self, action: #selector(showEventView), for: .touchUpInside)
        eventButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubViews(){
        view.addSubview(habbitButton)
        view.addSubview(eventButton)
    }
    
    private func applyConstraints(){
        NSLayoutConstraint.activate([
            habbitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 395),
            habbitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habbitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            habbitButton.bottomAnchor.constraint(equalTo: eventButton.topAnchor, constant: -16),
            habbitButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.topAnchor.constraint(equalTo: habbitButton.bottomAnchor, constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            eventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            eventButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -281),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    //MARK: Objc func
    @objc private func showHabbitView(){
        let vc = CreateHabbitVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func showEventView(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = "Создание трекера"
        navigationItem.titleView?.tintColor = UIColor(named: "NavTitle")
        navigationItem.title = "Создание трекера"
        configHabbitButton()
        configEventButton()
        addSubViews()
        applyConstraints()
    }
    
}


extension TrackerCreatingVC: CreateHabbitDelegateProtocol{
    func addNewTracker(tracker: Tracker, categoryName: String) {
        print("124312412412441241241")
        delegate?.addNewTracker(tracker: tracker, categoryName: categoryName)
    }
    
}
