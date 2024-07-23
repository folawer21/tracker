//
//  EventCell.swift
//  tracker
//
//  Created by Александр  Сухинин on 30.05.2024.
//

import UIKit


protocol EventCellDelegateProtocol: AnyObject{
    func showCategoryVC(vc: CategoriesVC)
    func categoryWasChosen(category: String)
}

final class EventCell: UICollectionViewCell {
    let tableView = UITableView()
    weak var viewModel: CategoriesViewModel?
    weak var delegate: EventCellDelegateProtocol?
    var daysArr: [String] = []
    override init(frame: CGRect){
        super.init(frame: frame)
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.backgroundColor = Colors.createHabbitEventSecondaryColor
        tableView.separatorStyle = .singleLine
        contentView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 0),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 0)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 16
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure("Blin")
    }
    func setVM(vm: CategoriesViewModel?){
        self.viewModel = vm
        self.viewModel?.setTrackerStore()
        self.viewModel?.onPickedCategoryChanged = {[weak self] categoryName in
            self?.delegate?.categoryWasChosen(category: categoryName)
            self?.setCategory(name: categoryName)}
    }
    
    private func setCategory(name: String){
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        cell?.detailTextLabel?.text = name
    }
}
extension EventCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = .systemFont(ofSize: 17)
        cell.backgroundColor = Colors.createHabbitEventSecondaryColor
        let cellText = NSLocalizedString("eventCell_category", comment: "")
        cell.textLabel?.text = cellText
        cell.layer.cornerRadius = 16
        cell.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
}
extension EventCell:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = CategoriesVC(viewModel: viewModel)
            delegate?.showCategoryVC(vc: vc)
        }
    }
}

