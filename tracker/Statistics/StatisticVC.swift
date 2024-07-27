//
//  StatisticVC.swift
//  tracker
//
//  Created by Александр  Сухинин on 23.07.2024.
//

import UIKit

final class StatisticVC: UIViewController {
    var bestPeriod = 0
    var perfectDaysCount = 0
    var completedTrackersCount = 0
    var meanValue = 0
    lazy var stubView = StubView(
        frame: CGRect.zero,
        title: NSLocalizedString("statistics_stub_text", comment: ""),
        imageName: "stubSmile"
    )
    var isEmpty = false
    lazy var statisticsStore = StatisticsStore()
    let tableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false

        return table
    }()
    let statistics = ["Лучший период", "Идеальные дни", "Трекеров завершено", "Среднее значение"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let navItemText = NSLocalizedString("statistics_navigation", comment: "")
        navigationItem.title = navItemText
        navigationItem.titleView?.tintColor = Colors.addButtonColor
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = Colors.blackBackgroundColor
        tableView.backgroundColor = Colors.blackBackgroundColor
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.cellIdentifier)
        tableView.allowsSelection = false
        tableView.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.reuseIdentifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isEmpty = statisticsStore.isEmpty
        if isEmpty {
            buildWithStub()
        } else {
            getStatistics()
            buildWithCategories()
            tableView.reloadData()
        }
    }
    private func getStatistics() {
        bestPeriod = statisticsStore.getBestPeriod()
        perfectDaysCount = statisticsStore.getPerfectDaysCount()
        completedTrackersCount = statisticsStore.getCompletedTrackersCount()
        meanValue = Int(statisticsStore.getMeanValue())
    }
    private func buildWithStub() {
        removeTable()
        addSubViewsWithStub()
        applyConstraintsWithStub()
    }
    private func buildWithCategories() {
        removeStub()
        addSubViewsWithCategories()
        applyConstraintsWithCategories()
    }
    private func addSubViewsWithCategories() {
        view.addSubview(tableView)
    }
    private func addSubViewsWithStub() {
        view.addSubview(stubView)
    }
    private func applyConstraintsWithStub() {
        applyStubConstraints()
    }
    private func applyConstraintsWithCategories() {
        applyTableConstraints()
    }
    private func applyTableConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }
    private func applyStubConstraints() {
        stubView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stubView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stubView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stubView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stubView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }
    private func removeStub() {
        self.view.willRemoveSubview(stubView)
        stubView.removeFromSuperview()
    }
    private func removeTable() {
        self.view.willRemoveSubview(tableView)
        tableView.removeFromSuperview()
    }

}

extension StatisticVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsCell.reuseIdentifier,
            for: indexPath
        ) as? StatisticsCell else {
            return UITableViewCell()
        }
        var number = 0
        if indexPath.row == 0 {
            cell.setupCell(number: bestPeriod, text: statistics[indexPath.row])
        }
        if indexPath.row == 1 {
            cell.setupCell(number: perfectDaysCount, text: statistics[indexPath.row])
        }
        if indexPath.row == 2 {
            cell.setupCell(number: completedTrackersCount, text: statistics[indexPath.row])
        }
        if indexPath.row == 3 {
            cell.setupCell(number: meanValue, text: statistics[indexPath.row])
        }

        return cell

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
}

extension StatisticVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 12
        }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
}
