//
//  TrackerRecordStore.swift
//  tracker
//
//  Created by Александр  Сухинин on 03.06.2024.
//

import Foundation
import CoreData

struct TrackerRecordStoreUpdate{
    let updatedIndexed: IndexSet
}

protocol TrackerRecordStoreDelegateProtocol:AnyObject{
    func update(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate)
}

final class TrackerRecordStore: NSObject{
    private let manager = CDManager.shared
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>
    private var updatedIndexes: IndexSet?
    weak var trackerStore : TrackerStore?
    weak var delegate: TrackerRecordStoreDelegateProtocol?
    override init(){
        self.context = manager.context
        let fetchedRequest = TrackerRecordCoreData.fetchRequest()
        fetchedRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.timetable, ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: manager.context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController = controller
        super.init()
        controller.delegate = self
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
    
    func setTrackerStore(store:TrackerStore){
        trackerStore = store
    }
    private func trackerRecord(from trackerRecordCD: TrackerRecordCoreData) throws -> TrackerRecord{
        guard let id = trackerRecordCD.id,
              let timetable = trackerRecordCD.timetable else {fatalError()}
        var trackerRecord = TrackerRecord(id: id, timetable: timetable)
        return trackerRecord
        
    }
    
    private func makeRecord(id: UUID, timetable: Date){
        let trackerCD = TrackerRecordCoreData(context: context)
        trackerCD.id = id
        trackerCD.timetable = timetable
        manager.saveContext()
    }
    
    private func deleteRecordMain(id:UUID,timetable: Date){
        guard let tracker = trackerStore?.getTrackerById(id: id) else {
            return
        }
        let type = tracker.type
        if type == .habbit{
            guard let record = getTrackerRecordsCD(id: id).first(where: {Calendar.current.isDate($0.timetable ?? Date(), equalTo: timetable, toGranularity: .day)}) else{
                return}
            deleteRecordFromCD(record: record)
            return
        }
        if type == .single{
            guard let record = getTrackerRecordsCD(id: id).first else {
                return}
            deleteRecordFromCD(record: record)
            return
        }
    }
    
    private func deleteRecordFromCD(record: TrackerRecordCoreData){
        context.delete(record)
        manager.saveContext()
    }
    
    func deleteAllRecords(){
        let trackersCD = fetchedResultsController.fetchedObjects
        for tracker in trackersCD! {
            context.delete(tracker)
        }
        manager.saveContext()
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
    
    private func singleHasDone(id: UUID) -> Bool{
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            guard let _ = try context.fetch(request).first else {
                return false
            }
            return true
        }catch{
            fatalError()
        }
    }
    
    private func daysCount(id: UUID) -> Int{
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let count = try context.fetch(request).count
            return count
        }catch{
            fatalError()
        }
    }
    
    func isEmptyRecords() -> Bool {
        return trackerRecords.isEmpty
    }
    
    func getAllCompletedTrackers() -> Int {
        return trackerRecords.count
    }
    
    func getMeanTrackersRecordCounts() -> Float {
        var daysCount : [Date : Int] = [:]
        for trackerRecord in trackerRecords {
            let date = trackerRecord.timetable
            if let count = daysCount[date] {
                daysCount[date] = count + 1
            } else {
                daysCount[date] = 1
            }
        }
        var sum = 0
        for days in daysCount {
            sum += days.value
        }
        return Float(sum / daysCount.count)
    }
    
    func deleteAllRecordsFor(id: UUID) {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let records = try context.fetch(request)
            for record in records {
                context.delete(record)
            }
        }catch{
            fatalError()
        }
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        updatedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>){
        guard let indexes = updatedIndexes else {fatalError()}
        delegate?.update(self, didUpdate: TrackerRecordStoreUpdate(updatedIndexed: indexes))
        updatedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .insert:
            if let insertedIndexPath = newIndexPath{
                updatedIndexes?.insert(insertedIndexPath.item)
            }
        case .delete:
            if let deletedIndexPath = indexPath{
                updatedIndexes?.insert(deletedIndexPath.item)
            }
        default:
            break
        }
    }
    func countPerfectDays() -> Int {
        trackerStore = TrackerStore(day: .monday)
        guard let trackers = trackerStore?.allTrackers else { return 0}
        func weekday(from date: Date) -> WeekDay? {
            guard let day = getDayOfWeek(from: date) else {
                return nil
            }
            switch day {
            case "Monday":
                return .monday
            case "Tuesday":
                return .tuesday
            case "Wednesday":
                return .wednesday
            case "Thursday":
                return .thursday
            case "Friday":
                return .friday
            case "Saturday":
                return .saturday
            case "Sunday":
                return .sunday
            default:
                return nil
            }
        }
        
        var recordsByDate: [Date: [UUID]] = [:]
        for record in trackerRecords {
            let dateOnly = Calendar.current.startOfDay(for: record.timetable)
            if recordsByDate[dateOnly] != nil {
                recordsByDate[dateOnly]?.append(record.id)
            } else {
                recordsByDate[dateOnly] = [record.id]
            }
        }
        var completedSingleTrackers: Set<UUID> = []
        for record in trackerRecords {
            if let tracker = trackers.first(where: { $0.id == record.id }), tracker.type == .single {
                completedSingleTrackers.insert(tracker.id)
            }
        }
        var perfectDaysCount = 0
        
        for (date, records) in recordsByDate {
            guard let dayOfWeek = weekday(from: date) else { break}
            let requiredTrackerIDs = trackers.filter {
                ($0.type == .habbit && $0.timetable.contains(dayOfWeek)) ||
                ($0.type == .single && !completedSingleTrackers.contains($0.id))
            }.map { $0.id }
            
            if Set(requiredTrackerIDs).isSubset(of: Set(records)) {
                perfectDaysCount += 1
            }
        }

        return perfectDaysCount
    }
    
    func maxSequenceOfPerfectDays() -> Int {
        func weekday(from date: Date) -> WeekDay? {
            guard let day = getDayOfWeek(from: date) else {
                return nil
            }
            switch day {
            case "Monday":
                return .monday
            case "Tuesday":
                return .tuesday
            case "Wednesday":
                return .wednesday
            case "Thursday":
                return .thursday
            case "Friday":
                return .friday
            case "Saturday":
                return .saturday
            case "Sunday":
                return .sunday
            default:
                return nil
            }
        }
        trackerStore = TrackerStore(day: .monday)
        guard let trackers = trackerStore?.allTrackers else { return 0}
        var recordsByDate: [Date: [UUID]] = [:]
        for record in trackerRecords {
            let dateOnly = Calendar.current.startOfDay(for: record.timetable)
            if recordsByDate[dateOnly] != nil {
                recordsByDate[dateOnly]?.append(record.id)
            } else {
                recordsByDate[dateOnly] = [record.id]
            }
        }
        
        var completedSingleTrackers: Set<UUID> = []
        for record in trackerRecords {
            if let tracker = trackers.first(where: { $0.id == record.id }), tracker.type == .single {
                completedSingleTrackers.insert(tracker.id)
            }
        }
        
        var perfectDays: Set<Date> = []
        for (date, records) in recordsByDate {
            guard let dayOfWeek = weekday(from: date) else { break}
            let requiredTrackerIDs = trackers.filter {
                ($0.type == .habbit && $0.timetable.contains(dayOfWeek)) ||
                ($0.type == .single && !completedSingleTrackers.contains($0.id))
            }.map { $0.id }
            
            if Set(requiredTrackerIDs).isSubset(of: Set(records)) {
                perfectDays.insert(date)
            }
        }
        
       
        let sortedPerfectDays = perfectDays.sorted()
        var maxSequence = 0
        var currentSequence = 0
        var previousDate: Date?
        
        for date in sortedPerfectDays {
            if let previous = previousDate, Calendar.current.isDate(date, inSameDayAs: Calendar.current.date(byAdding: .day, value: 1, to: previous)!) {
                currentSequence += 1
            } else {
                maxSequence = max(maxSequence, currentSequence)
                currentSequence = 1
            }
            previousDate = date
        }
        maxSequence = max(maxSequence, currentSequence) 
        
        return maxSequence
    }
    
    func getDayOfWeek(from date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dayOfWeek = dateFormatter.string(from: date)
        return dayOfWeek
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
    
    func singleIsDone(id: UUID) -> Bool {
        self.singleHasDone(id: id)
    }
    
    func getTrackerDoneCount(id: UUID) -> Int {
        self.daysCount(id: id)
    }
}
