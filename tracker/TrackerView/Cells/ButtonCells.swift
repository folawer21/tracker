//
//  CategoryButtonCell.swift
//  tracker
//
//  Created by Александр  Сухинин on 29.05.2024.
//

import UIKit

protocol ButtonCellDelegateProtocol: AnyObject {
    func showTimeTable(vc: TimeTableVC)
    func showCategoryVC(vc: CategoriesVC)
    func timetableSettedDelegate(flag: Bool)
    func categoryWasChosen(category: String)
}

final class ButtonCells: UICollectionViewCell {
    weak var viewModel: CategoriesViewModel?
    let tableView = UITableView()
    var daysArr: [String] = []
    var selectedCategory: String?
    weak var delegate: ButtonCellDelegateProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Colors.createHabbitEventSecondaryColor
        tableView.separatorStyle = .singleLine
        contentView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 16
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    func setVM(vm: CategoriesViewModel?) {
        self.viewModel = vm
        self.viewModel?.setTrackerStore()
        self.viewModel?.onPickedCategoryChanged = {[weak self] categoryName in
            self?.delegate?.categoryWasChosen(category: categoryName)
            self?.setCategory(name: categoryName)}
    }
    func setCategory(name: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        cell?.detailTextLabel?.text = name
    }

}
extension ButtonCells: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = .systemFont(ofSize: 17)
        cell.backgroundColor = Colors.createHabbitEventSecondaryColor
        if indexPath.row ==  0 {
            if let selectedCategory = selectedCategory {
                let cellText = NSLocalizedString("buttonCells_category", comment: "")
                cell.textLabel?.text = cellText
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.detailTextLabel?.text = selectedCategory
                return cell
            }
            let cellText = NSLocalizedString("buttonCells_category", comment: "")
            cell.textLabel?.text = cellText
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            return cell
        } else {
            if !daysArr.isEmpty {
                let cellText = NSLocalizedString("buttonCells_timetable", comment: "")
                cell.textLabel?.text = cellText
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                let joinedDays = daysArr.joined(separator: ", ")
                cell.detailTextLabel?.text = joinedDays
                return cell
            }
            let cellText = NSLocalizedString("buttonCells_timetable", comment: "")
            cell.textLabel?.text = cellText
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
}
extension ButtonCells: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = CategoriesVC(viewModel: viewModel)
            viewModel?.model.delegate = vc
            if let selectedCategory = selectedCategory {
                viewModel?.setPickedCategory(name: selectedCategory)
                delegate?.showCategoryVC(vc: vc)
            } else {
                delegate?.showCategoryVC(vc: vc)
            }
        }
        if indexPath.row == 1 {
            let vc = TimeTableVC()
            vc.delegate = self
            delegate?.showTimeTable(vc: vc)
        }
    }
}

extension ButtonCells: TimeTableVcDelegateProtocol {
    func timetableSetted(flag: Bool) {
        delegate?.timetableSettedDelegate(flag: flag)
    }

    func setDays(days: [String]) {
        daysArr = days
        let joinedDays = days.joined(separator: ", ")
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        cell?.detailTextLabel?.text = joinedDays

    }
    func getDaysArr() -> [String ]{
        return daysArr
    }
}
