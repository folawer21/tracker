//
//  TrackerRecordStore.swift
//  tracker
//
//  Created by Александр  Сухинин on 03.06.2024.
//

import Foundation
import CoreData

final class TrackerRecordStore: NSObject{
    let manager = CDManager.shared
    private let context: NSManagedObjectContext
    var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>
    
    override init(){
        self.context = manager.context
        let fetchedRequest = TrackerRecordCoreData.fetchRequest()
        fetchedRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.timetable, ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: manager.context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController = controller
        super.init()
        do{
            try controller.performFetch()
        }catch{
            fatalError()
        }
    }
    var trackerRecords: [TrackerRecord]{
        guard let objects = fetchedResultsController.fetchedObjects,
              let trackerRecords = try? objects.map({try self.trackerRecord(from: $0)}) else { return []}
        return trackerRecords
    }

    private func trackerRecord(from trackerRecordCD: TrackerRecordCoreData) throws -> TrackerRecord{
        guard let id = trackerRecordCD.id,
              let timetable = trackerRecordCD.timetable else {fatalError()}
        var trackerRecord = TrackerRecord(id: id, timetable: timetable)
        return trackerRecord
        
    }
    
    private func makeRecord(id: UUID, timetable: Date){
        let records = getTrackerRecordsCD(id: id)
        let recordIndex = records.firstIndex(where: {Calendar.current.isDate($0.timetable ?? Date(), equalTo: timetable, toGranularity: .day)}) ?? 0
        if recordIndex == 0{
            deleteRecordFromCD(record: records[recordIndex])
        }else{
            let trackerCD = TrackerRecordCoreData()
            trackerCD.id = id
            trackerCD.timetable = timetable
        }
        manager.saveContext()
    }
    
    private func deleteRecordMain(id:UUID,timetable: Date){
        guard let record = getTrackerRecordsCD(id: id).first(where: {Calendar.current.isDate($0.timetable ?? Date(), equalTo: timetable, toGranularity: .day)}) else{fatalError()}
        deleteRecordFromCD(record: record)
    }
    
    private func deleteRecordFromCD(record: TrackerRecordCoreData){
        context.delete(record)
    }
    
    private func getTrackerRecords(id: UUID) -> [TrackerRecord]{
        let records = trackerRecords.filter({$0.id == id})
        return records
    }
    
    private func getTrackerRecordsCD(id: UUID) -> [TrackerRecordCoreData]{
        guard let recordsCD = fetchedResultsController.fetchedObjects?.filter({$0.id == id}) else {fatalError()}
        return recordsCD
    }

    private func isRecorded(id:UUID,date: Date) -> Bool{
        let index = trackerRecords.firstIndex(where: {$0.id == id && Calendar.current.isDate($0.timetable, equalTo: date, toGranularity: .day)})
        if index != nil {
            return true
        }else{
            return false
        }
    }
}

extension TrackerRecordStore: TrackerRecordStoreProtocol{
    func deleteRecord(id: UUID, timetable: Date){
        self.deleteRecordMain(id: id, timetable: timetable)
    }
    
    func makeNewRecord(id: UUID, timetable: Date){
        self.makeRecord(id: id, timetable: timetable)
    }
    
    func isRecordedByDate(id: UUID, date: Date) -> Bool {
        self.isRecorded(id: id, date: date)
    }
    
    
}
