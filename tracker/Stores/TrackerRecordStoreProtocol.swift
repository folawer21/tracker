//
//  TrackerRecordStoreProtocol.swift
//  tracker
//
//  Created by Александр  Сухинин on 08.06.2024.
//

import Foundation

protocol TrackerRecordStoreProtocol: AnyObject{
    func makeNewRecord(id: UUID,timetable: Date)
    func deleteRecord(id:UUID,timetable:Date)
    func isRecordedByDate(id:UUID,date: Date) -> Bool
}
