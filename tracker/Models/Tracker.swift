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
 
    static func timetableFromJSON(json: String) -> [WeekDay]?{
        let decoder = JSONDecoder()
        if let data = json.data(using: .utf8){
            return try? decoder.decode([WeekDay].self, from: data)
        }else{
            return nil
        }
    }
    
    static func typeFromJSON(json: String) -> TrackerType?{
        let decoder = JSONDecoder()
        if let data = json.data(using: .utf8){
            return try? decoder.decode(TrackerType.self, from: data)
        }else{
            return nil
        }
    }
    
    func typeToJSON() -> String?{
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(type){
            return String(data:data,encoding: .utf8)
        }else{
            return nil
        }
    }
    
    static func typeToJSON(fromType: TrackerType) -> String?{
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(fromType){
            return String(data:data,encoding: .utf8)
        }else{
            return nil
        }
    }
    
    static func timetableToJSON(fromTimetable: [WeekDay]) -> String?{
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(fromTimetable){
            return String(data:data,encoding: .utf8)
        }else{
            return nil
        }
    }
    
    
    func timetableToJSON() -> String?{
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(timetable){
            return String(data:data,encoding: .utf8)
        }else{
            return nil
        }
    }
    
    
    
}

enum WeekDay: String, Codable{
    case monday =  "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
    case sunday = "Вс"
}
