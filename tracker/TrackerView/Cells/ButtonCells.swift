//
//  CategoryButtonCell.swift
//  tracker
//
//  Created by Александр  Сухинин on 29.05.2024.
//

import UIKit

protocol ButtonCellDelegateProtocol: AnyObject{
    func showTimeTable(vc: TimeTableVC)
    func showCategoryVC(vc: CategoriesVC)
    func timetableSettedDelegate(flag: Bool)
    func categoryWasChosen(category: String)
}

final class ButtonCells: UICollectionViewCell {
    weak var viewModel: CategoriesViewModel?
    let tableView = UITableView()
    var daysArr: [String] = []
    weak var delegate: ButtonCellDelegateProtocol?
    override init(frame: CGRect){
        super.init(frame: frame)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "ButtonCellsColor")
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
        fatalError()
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
extension ButtonCells: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = .systemFont(ofSize: 17)
        cell.backgroundColor = UIColor(named: "ButtonCellsColor")
        if indexPath.row == 0{
            cell.textLabel?.text = "Категория"
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            return cell
        }else{
            cell.textLabel?.text = "Расписание"
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
}
extension ButtonCells:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = CategoriesVC(viewModel: viewModel)
            viewModel?.model.delegate = vc
            delegate?.showCategoryVC(vc: vc)
        }
        if indexPath.row == 1{
            let vc = TimeTableVC()
            vc.delegate = self
            delegate?.showTimeTable(vc: vc)
        }
    }      
}

extension ButtonCells:TimeTableVcDelegateProtocol{
    func timetableSetted(flag: Bool) {
        delegate?.timetableSettedDelegate(flag: flag)
    }
    
    func setDays(days: [String]) {
        let joinedDays = days.joined(separator: ", ")
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        cell?.detailTextLabel?.text = ""
//        if days.count == 7 {
//            cell?.detailTextLabel?.text = "Каждый день"
//        }else{
//            cell?.detailTextLabel?.text = joinedDays}
        cell?.detailTextLabel?.text = joinedDays
        daysArr = days
    }
    func getDaysArr() -> [String]{
        return daysArr
    }
}

