//
//  FiltresVC.swift
//  tracker
//
//  Created by Александр  Сухинин on 25.07.2024.
//

import UIKit

final class FiltresVC: UIViewController {
    private let reuseIdentifier = "FilterCell"
    private let tableView = {
        let table = UITableView()
        table.backgroundColor = Colors.createHabbitEventSecondaryColor
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = Colors.blackBackgroundColor
        tableView.register(FilterCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

extension FiltresVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? FilterCell else {return UITableViewCell()}
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
}

extension FiltresVC: UITableViewDelegate {
    
}
