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
    private let categoryStore = TrackerCategoryStore()
    var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>
    
    weak var delegate: TrackerStoreDelegate?
    
    override init(){
        self.context = manager.context
        let fetchedRequest = TrackerCoreData.fetchRequest()
        fetchedRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.createdAt, ascending: true)]
        //Когда добавятся категории  придется здесь добавить sectionNameKeyPath?
        let controller = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController = controller
        super.init()
        controller.delegate = self
        do{
            try controller.performFetch()
        }catch{
            fatalError()
        }
            
    }
    
    var trackers: [Tracker]{
        guard
            let objects = fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({try self.tracker(from: $0)}) else {return []}
        return trackers
    }
    
    func addNewTracker(tracker: Tracker,category: String) throws {
        let colorHex = marshaling.hexString(from: tracker.color)
        let daysData = daysTransformer.transformedValue(tracker.timetable) as? NSObject
        let typeData = typeTransformer.transformedValue(tracker.type) as? NSObject
        guard let categoryCD = categoryStore.getCategoryCoreData(categoryName: category) else{
            fatalError()
        }
        let trackerData = TrackerCoreData(context: context)
        trackerData.category = categoryCD
        trackerData.emoji = tracker.emoji
        trackerData.id = tracker.id
        trackerData.name = tracker.name
        trackerData.color = colorHex
        trackerData.timetable = daysData
        trackerData.type = typeData
        trackerData.createdAt = tracker.createdAt
        
        manager.saveContext()
    }
    
    func getTrackerCD(from tracker: Tracker, categoryName : String) -> TrackerCoreData?{
        guard let timetableCD = daysTransformer.transformedValue(tracker.timetable) as? NSArray ,
              let typeCD = typeTransformer.transformedValue(tracker.type) as? NSObject else {
            fatalError()
        }
        
        let categoryCD = categoryStore.getCategoryCoreData(categoryName: categoryName)
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
              let timetable = trackerCoreData.timetable as? [WeekDay],
              let type = trackerCoreData.type as? TrackerType else{
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
    
    
}
