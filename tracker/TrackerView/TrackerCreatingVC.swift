//
//  TrackerCreatingVC.swift
//  tracker
//
//  Created by Александр  Сухинин on 29.05.2024.
//

import UIKit

protocol TrackerCreatingDelegateProtocol: AnyObject {
    func addNewTracker(tracker: Tracker, categoryName: String)
    func deleteTracker(tracker: Tracker)
}

final class TrackerCreatingVC: UIViewController {
    let habbitButton: UIButton = UIButton()
    let eventButton: UIButton = UIButton()
    weak var delegate: TrackerCreatingDelegateProtocol?

    private func configHabbitButton( ){
        let habbitButtonText = NSLocalizedString("tracker_creating_cell_habbitButton", comment: "")
        habbitButton.backgroundColor = Colors.trackerCreatingVCbuttonsColors
        habbitButton.setTitleColor(Colors.trackerCreatingVCbuttonsTextColors, for: .normal)
        habbitButton.titleLabel?.font = .systemFont(ofSize: 16)
        habbitButton.setTitle(habbitButtonText, for: .normal)
        habbitButton.layer.cornerRadius = 16
        habbitButton.addTarget(self, action: #selector(showHabbitView), for: .touchUpInside)
        habbitButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configEventButton( ){
        let eventButtonText = NSLocalizedString("tracker_creating_cell_eveneButton", comment: "")
        eventButton.backgroundColor = Colors.trackerCreatingVCbuttonsColors
        eventButton.setTitleColor(Colors.trackerCreatingVCbuttonsTextColors, for: .normal)
        eventButton.titleLabel?.font = .systemFont(ofSize: 16)
        eventButton.setTitle(eventButtonText, for: .normal)
        eventButton.layer.cornerRadius = 16
        eventButton.addTarget(self, action: #selector(showEventView), for: .touchUpInside)
        eventButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addSubViews( ){
        view.addSubview(habbitButton)
        view.addSubview(eventButton)
    }

    private func applyConstraints( ){
        NSLayoutConstraint.activate([
            habbitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 395),
            habbitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habbitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            habbitButton.bottomAnchor.constraint(equalTo: eventButton.topAnchor, constant: -16),
            habbitButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.topAnchor.constraint(equalTo: habbitButton.bottomAnchor, constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            eventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    // MARK: Objc func
    @objc private func showHabbitView( ){
        let vc = CreateHabbitVC(isEditVC: false)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func showEventView( ){
        let vc = CreateEventVC(isEditVC: false)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let navItemTitle = NSLocalizedString("tracker_creating_nav_title", comment: "")
        view.backgroundColor = Colors.blackBackgroundColor
        navigationController?.navigationBar.topItem?.title = navItemTitle
        navigationItem.titleView?.tintColor = UIColor(named: "NavTitle")
        navigationItem.title = navItemTitle
        configHabbitButton()
        configEventButton()
        addSubViews()
        applyConstraints()
    }

}
extension TrackerCreatingVC: CreateHabbitDelegateProtocol & CreateEventDelegateProtocol {
    func addNewTracker(tracker: Tracker, categoryName: String) {
        delegate?.addNewTracker(tracker: tracker, categoryName: categoryName)
    }

    func deleteTracker(tracker: Tracker) {
        delegate?.deleteTracker(tracker: tracker)
    }

}
