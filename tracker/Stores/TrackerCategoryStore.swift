//
//  TrackerCategoryStore.swift
//  tracker
//
//  Created by Александр  Сухинин on 03.06.2024.
//

import Foundation
import CoreData

protocol TrackerCategoryDelegate: AnyObject{
    
}

final class TrackerCategoryStore: NSObject{
    private let manager = CDManager.shared
    private let trackerStore = TrackerStore()
    private let context: NSManagedObjectContext
    var fetchedResultsController:NSFetchedResultsController<TrackerCategoryCoreData>
    
    weak var delegate: TrackerCategoryDelegate?
    
    override init(){
        self.context = manager.context
        let fetchedRequest = TrackerCategoryCoreData.fetchRequest()
        fetchedRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
        
        let conroller = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchedResultsController = conroller
        
        super.init()
        conroller.delegate = self
        do{
            try conroller.performFetch()
        }catch{
            fatalError()
        }
    }
    
    var categories: [TrackerCategory]{
        guard let objects = self.fetchedResultsController.fetchedObjects,
              let categories = try? objects.map({try self.category(from: $0)}) else {return []}
        return categories
    }
    
    func category(from categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory{
        guard let title = categoryCoreData.title,
              let trackersCD = categoryCoreData.trackers?.allObjects as? [TrackerCoreData],
              let trackers = try? trackersCD.map({try trackerStore.tracker(from: $0)}) else {
            fatalError()
        }
        let category = TrackerCategory(title: title, trackerList: trackers)
        return category
    }
    
    func newCategory(categoryName: String,trackers: [Tracker] = [] ){
        let category = TrackerCategoryCoreData(context: context)
        guard let trackersCD = trackers.map({trackerStore.getTrackerCD(from: $0, categoryName: categoryName)}) as? NSSet else { fatalError() }
        category.title = categoryName
        category.trackers = trackersCD
        manager.saveContext()
    }
    
     func getCategoryCoreData(categoryName: String)  -> TrackerCategoryCoreData?{
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", categoryName)
        do {
            guard let category = try context.fetch(request).first else {
                return nil
            }
            return category
        }catch{
            return nil
        }
    }
    
    func addTrackerToCategory(tracker: Tracker,categoryName: String){
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", categoryName)
        do{
            guard let category = try context.fetch(request).first else {
                newCategory(categoryName: categoryName, trackers: [tracker])
                return
            }
            guard let trackersCD = trackerStore.getTrackerCD(from: tracker, categoryName: categoryName) else {fatalError()}
            category.addToTrackers(trackersCD)
            manager.saveContext()
        }catch{
            fatalError()
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate{
    
}
