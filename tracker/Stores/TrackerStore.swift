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
    var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>
    
    weak var delegate: TrackerStoreDelegate?
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        let fetchedRequest = TrackerCoreData.fetchRequest()
        fetchedRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.createdAt, ascending: true)]
        //Когда добавятся категории  придется здесь добавить sectionNameKeyPath?
        let controller = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController = controller
        super.init()
        controller.delegate = self
        try controller.performFetch()
    }
    
    var trackers: [Tracker]{
        guard
            let objects = fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({try self.tracker(from: $0)}) else {return []}
        return trackers
    }
    
    func addNewTracker(tracker: Tracker,category: TrackerCategory) throws {
        let colorHex = marshaling.hexString(from: tracker.color)
        let daysData = daysTransformer.transformedValue(tracker.timetable) as? NSObject
        let typeData = typeTransformer.transformedValue(tracker.type) as? NSObject
        guard let categoryCD = getCategoryCoreData(category: category) else{
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
        
        manager.saveContext()
    }
    
    private func getCategoryCoreData(category: TrackerCategory)  -> TrackerCategoryCoreData?{
        let name = category.title
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", name)
        do {
            guard let category = try context.fetch(request).first else {
                return nil
            }
            return category
        }catch{
            return nil
        }
    }
   
    
    private func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker{
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
