//
//  FiltresVC.swift
//  tracker
//
//  Created by Александр  Сухинин on 25.07.2024.
//

import UIKit
enum Filtres: String {
    case all
    case today
    case completed
    case uncompleted
}

protocol FiltresVCDelegateProtocol: AnyObject {
    func filterDidChosen(filter: Filtres)
}

final class FiltresVC: UIViewController {
    private let reuseIdentifier = "FilterCell"
    var chosenFilter: Filtres?
    weak var delegate: FiltresVCDelegateProtocol?
    private let tableView = {
        let table = UITableView()
        table.backgroundColor = Colors.createHabbitEventSecondaryColor
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        navigationItem.title = NSLocalizedString("filter_button", comment: "")
        navigationItem.titleView?.tintColor = Colors.addButtonColor
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.backgroundColor = Colors.blackBackgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -340)
        ])
        view.backgroundColor = Colors.blackBackgroundColor
        tableView.register(FilterCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

extension FiltresVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? FilterCell else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            cell.setupCell(isChosen: false, filterName: NSLocalizedString("all_filter", comment: ""))
            if chosenFilter == .all {
                cell.showChosenImage()
            }
            cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            cell.contentView.layer.cornerRadius = 16
            return cell
        case 1:
            cell.setupCell(isChosen: false, filterName: NSLocalizedString("today_filter", comment: ""))
            if chosenFilter == .today {
                cell.showChosenImage()
            }
            return cell
        case 2:
            cell.setupCell(isChosen: false, filterName: NSLocalizedString("completed_filter", comment: ""))
            if chosenFilter == .completed {
                cell.showChosenImage()
            }
            return cell
        case 3:
            cell.setupCell(isChosen: false, filterName: NSLocalizedString("uncompleted_filter", comment: ""))
            if chosenFilter == .uncompleted {
                cell.showChosenImage()
            }
            cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
            cell.contentView.layer.cornerRadius = 16
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension FiltresVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterCell else {
            return
        }
        switch indexPath.row {
        case 0:
            delegate?.filterDidChosen(filter: Filtres.all)
        case 1:
            delegate?.filterDidChosen(filter: Filtres.today)
        case 2:
            delegate?.filterDidChosen(filter: Filtres.completed)
        case 3:
            delegate?.filterDidChosen(filter: Filtres.uncompleted)
        default:
            return
        }
        cell.showChosenImage()
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterCell else {
            return
        }
        cell.hideChosenImage()
    }
}
