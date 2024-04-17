//
//  Tracker.swift
//  tracker
//
//  Created by Александр  Сухинин on 17.04.2024.
//

import UIKit

enum TrackerType{
    case habbit
    case single
}

struct Tracker{
    let id: UUID
    let type: TrackerType
    let name: String
    let emoji: String
    let timetable: String
    
}
