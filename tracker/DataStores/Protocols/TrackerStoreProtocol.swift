//
//  TrackerStoreProtocol.swift
//  tracker
//
//  Created by Александр  Сухинин on 07.06.2024.
//

import Foundation

protocol TrackerStoreProtocol: AnyObject{
    func numberOfRowsInSection(_ section: Int) -> Int
    func object(at indexPath: IndexPath) -> Tracker?
    func addTracker(_ tracker: Tracker,category: String)
    func setDay(day: WeekDay)
    func deleteTracker(id: UUID?)
    func editTracker(id: UUID, categoryName: String)
    func getTracker(id: UUID) -> Tracker?
    func setRecordStore(store: TrackerRecordStore)
    var isEmpty: Bool {get}
    
}
