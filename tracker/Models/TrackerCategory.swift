//
//  TrackerCategory.swift
//  tracker
//
//  Created by Александр  Сухинин on 17.04.2024.
//

import Foundation

struct TrackerCategory: Equatable{
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.title == rhs.title
    }
    let title: String
    let trackerList: [Tracker]
}
