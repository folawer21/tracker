//
//  TrackerStore.swift
//  tracker
//
//  Created by Александр  Сухинин on 03.06.2024.
//

import Foundation
import CoreData

struct TrackerStoreUpdate{
    let insertedIndexes: IndexSet
}

protocol TrackerStoreDelegate: AnyObject{
    func store(_ store: TrackerStore, didUpdate update:TrackerStoreUpdate )
}

final class TrackerStore: NSObject{
    private let manager = CDManager.shared
    private let daysTransformer = DaysValueTransformer()
    private let typeTransformer = TypeValueTransformer()
    private let context: NSManagedObjectContext
    private let marshaling = UIColorMarshalling()
    private var insertedIndexes: IndexSet?
    weak var categoryStore: TrackerCategoryStore?
    var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>
    private var day : WeekDay
    weak var delegate: TrackerStoreDelegate?
    
    init(day: WeekDay){
        self.context = manager.context
        self.day = day
        let fetchedRequest = TrackerCoreData.fetchRequest()
        fetchedRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.createdAt, ascending: true)]
        //Когда добавятся категории  придется здесь добавить sectionNameKeyPath?
        let controller = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController = controller
        super.init()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    var trackers: [Tracker]{
        guard
            let objects = fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({try self.tracker(from: $0)}) else {
            return []}
        let filteredTrackers = trackers.filter{tracker in
            tracker.timetable.first(where: {$0.rawValue == self.day.rawValue}) != nil
        }
        print(day)
        print(trackers)
        print(filteredTrackers)
        return filteredTrackers
    }
        
    func initializeFetchedResultsController(withPredicate predicate:NSPredicate? = nil){
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
               fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.createdAt, ascending: true)]
               fetchRequest.predicate = predicate
               
       fetchedResultsController = NSFetchedResultsController(
           fetchRequest: fetchRequest,
           managedObjectContext: self.context,
           sectionNameKeyPath: nil,
           cacheName: nil
       )
       fetchedResultsController.delegate = self
       
       do {
           try fetchedResultsController.performFetch()
       } catch {
           fatalError("Failed to initialize FetchedResultsController: \(error)")
       }
    }
    
    func setDay(day: WeekDay){
        self.day = day
    }
    
    
    func addNewTracker(tracker: Tracker,category: String) throws {
//        let colorHex = marshaling.hexString(from: tracker.color)
//        let daysData = daysTransformer.transformedValue(tracker.timetable) as? NSObject
//        let typeData = typeTransformer.transformedValue(tracker.type) as? NSObject
//        guard let categoryCD = categoryStore.getCategoryCoreData(categoryName: category) else{
//            fatalError()
//        }
//        let trackerData = TrackerCoreData(context: context)
//        trackerData.category = categoryCD
//        trackerData.emoji = tracker.emoji
//        trackerData.id = tracker.id
//        trackerData.name = tracker.name
//        trackerData.color = colorHex
//        trackerData.timetable = daysData
//        trackerData.type = typeData
//        trackerData.createdAt = tracker.createdAt
//        manager.saveContext()
        categoryStore?.addTrackerToCategory(tracker: tracker, categoryName: category)
    }
    
    func getTrackerCD(from tracker: Tracker, categoryName : String) -> TrackerCoreData?{
//        guard let timetableCD = daysTransformer.transformedValue(tracker.timetable) as? NSData ,
//              let typeCD = typeTransformer.transformedValue(tracker.type) as? NSData else {
//            fatalError()
//        }
//        
        guard let timetableCD = tracker.timetableToJSON() ,
              let typeCD = tracker.typeToJSON()else {
            fatalError()
        }
        
        let categoryCD = categoryStore?.getCategoryCoreData(categoryName: categoryName)
        let colorhex = marshaling.hexString(from: tracker.color)
        let trackerCD = TrackerCoreData(context: context)
        trackerCD.id = tracker.id
        trackerCD.color = colorhex
        trackerCD.createdAt = tracker.createdAt
        trackerCD.emoji = tracker.emoji
        trackerCD.category = categoryCD
        trackerCD.timetable = timetableCD
        trackerCD.type = typeCD
        trackerCD.name = tracker.name

        return trackerCD
    
    }
   
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker{
        guard let colorHex = trackerCoreData.color,
              let createdAt = trackerCoreData.createdAt,
              let emoji = trackerCoreData.emoji,
              let id = trackerCoreData.id,
              let name = trackerCoreData.name,
              let timetableCD = trackerCoreData.timetable,
              let typeCd = trackerCoreData.type,
              let type = Tracker.typeFromJSON(json: typeCd),
              let timetable = Tracker.timetableFromJSON(json: timetableCD)
        else{
            fatalError("TrackerStore: tracker")
        }
        let color = marshaling.color(from: colorHex)
        let tracker = Tracker(id: id, type: type, name: name, emoji: emoji, color: color, createdAt: createdAt, timetable: timetable)
        return tracker
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        guard let indexes = insertedIndexes else {fatalError()}
        delegate?.store(self, didUpdate: TrackerStoreUpdate.init(insertedIndexes: indexes))
        insertedIndexes = nil
    }
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert{
            guard let indexPath = newIndexPath else {fatalError()}
            insertedIndexes?.insert(indexPath.item)
        }else{
            return
        }
    }
}


extension TrackerStore: TrackerStoreProtocol{
    func numberOfRowsInSection(_ section: Int) -> Int {
        return trackers.count
        //TODO: Когда добавятся категории переписать под них
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        return trackers[indexPath.row]
    }
    
    func addTracker(_ tracker: Tracker, category: String){
        do{
            try addNewTracker(tracker: tracker, category: category)}
        catch{
            print(error)
        }
    }
    
    func setCategoryStore(categoryStore: TrackerCategoryStore){
        self.categoryStore = categoryStore
    }
    
    var isEmpty: Bool{
//        categoryStore?.deleteCategory(categoryName: "Какашка")
        return trackers.isEmpty
    }
    
    
}
