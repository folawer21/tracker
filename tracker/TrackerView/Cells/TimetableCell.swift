//
//  TimetableCell.swift
//  tracker
//
//  Created by Александр  Сухинин on 29.05.2024.
//

import UIKit

final class TimetableCell: UITableViewCell{
    let switcher = UISwitch()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        switcher.isOn = false
        switcher.onTintColor = .ypBlue
        accessoryView = switcher
        self.textLabel?.font = .systemFont(ofSize: 17)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not implemented")
    }
}
