//
//  Tracker.swift
//  tracker
//
//  Created by Александр  Сухинин on 17.04.2024.
//
import UIKit

enum TrackerType: Codable{
    case habbit
    case single
}

struct Tracker{
    let id: UUID
    let type: TrackerType
    let name: String
    let emoji: String
    let color: UIColor
    let createdAt: Date
    let timetable: [WeekDay]
}

enum WeekDay: String, Codable{
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
    case sunday = "Вс"
}
