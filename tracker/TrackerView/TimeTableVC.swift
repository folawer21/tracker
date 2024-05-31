//
//  TimeTableVC.swift
//  tracker
//
//  Created by Александр  Сухинин on 29.05.2024.
//


import UIKit

protocol TimeTableVcDelegateProtocol: AnyObject{
    func setDays(days: [String])
    func getDaysArr() -> [String]
    func timetableSetted(flag: Bool)
}

final class TimeTableVC: UIViewController{
    let tableView = UITableView()
    let doneButton = UIButton()
    let days = ["Понедельник","Вторник","Среда","Четверг","Пятница","Суббота","Воскресенье"]
    var selectedDays: [String] = []
    weak var delegate: TimeTableVcDelegateProtocol?
    
    @objc func doneButtonTapped(){
        delegate?.setDays(days: selectedDays)
        delegate?.timetableSetted(flag: !selectedDays.isEmpty)
        navigationController?.popViewController(animated: true)
}
    
    func configTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TimetableCell.self, forCellReuseIdentifier: "day")
        tableView.layer.cornerRadius = 16
    }
    
    func configButton(){
        doneButton.setTitle("Готово", for: .normal)
        doneButton.backgroundColor = .black
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16)
        doneButton.layer.cornerRadius = 16
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        navigationItem.title = "Расписание"
        configTableView()
        configButton()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        view.addSubview(tableView)
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -16),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor,constant: -47),
            doneButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 47),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    func addDay(day:String){
        selectedDays.append(day)
    }
    @objc func switcherTapped(sender: UISwitch){
        guard let day = sender.userActivity?.userInfo?["day"] as? String else {
            return}
        switch day {
            case "Понедельник":
                addDay(day: "Пн")
            case "Вторник":
                addDay(day: "Вт")
            case "Среда":
                addDay(day: "Ср")
            case "Четверг":
                addDay(day: "Чт")
            case "Пятница":
                addDay(day: "Пт")
            case "Суббота":
                addDay(day: "Сб")
            case "Воскресенье":
                addDay(day: "Вс")
            default:
                print("error")
            }

        
    }
}

extension TimeTableVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "day", for: indexPath) as? TimetableCell else {return UITableViewCell()}
        cell.textLabel?.text = days[indexPath.row]
        cell.backgroundColor = UIColor(named: "TextFieldColor")
        cell.switcher.addTarget(self, action: #selector(self.switcherTapped(sender:)), for: .touchUpInside)
        let activity = NSUserActivity(activityType: "aa")
        activity.userInfo = ["day" : days[indexPath.row]]
        cell.switcher.userActivity = activity
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        days.count
    }
}

extension TimeTableVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 7
    }
}
