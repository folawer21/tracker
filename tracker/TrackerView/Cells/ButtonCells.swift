//
//  CategoryButtonCell.swift
//  tracker
//
//  Created by Александр  Сухинин on 29.05.2024.
//

import UIKit

//final class ButtonCells: UICollectionViewCell{
//    let label = UILabel()
////    let button = UIButton()
//    
//    override init(frame: CGRect){
//        super.init(frame: frame)
//        
//        
//        
//        contentView.addSubview(label)
//        self.backgroundColor = UIColor(named: "TextFieldColor")
//        label.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
//            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -26),
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
//            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -41)
//        ])
//    }
//    
//    
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        assertionFailure("Blin")
//    }
//}
protocol ButtonCellDelegateProtocol: AnyObject{
    func showTimeTable(vc: TimeTableVC)
}

final class ButtonCells: UICollectionViewCell {
    let tableView = UITableView()
    var daysArr: [String] = []
    weak var delegate: ButtonCellDelegateProtocol?
    override init(frame: CGRect){
        super.init(frame: frame)
//        self.backgroundColor = UIColor(named: "TextFieldColor")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "TextFieldColor")
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
    
}
extension ButtonCells: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = .systemFont(ofSize: 17)
        cell.backgroundColor = UIColor(named: "TextFieldColor")
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
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        if indexPath.row == 1{
//            
//        }
//        print(delegate)
//        delegate?.showTimeTable()
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
            let vc = TimeTableVC()
            vc.delegate = self
            delegate?.showTimeTable(vc: vc)
        }
    }
    

}

extension ButtonCells:TimeTableVcDelegateProtocol{
    func setDays(days: [String]) {
        let joinedDays = days.joined(separator: ", ")
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        cell?.detailTextLabel?.text = joinedDays
        daysArr = days
    }
    func getDaysArr() -> [String]{
        return daysArr
    }
}
