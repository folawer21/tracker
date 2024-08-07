//
//  TrackerCategoryStore.swift
//  tracker
//
//  Created by Александр  Сухинин on 03.06.2024.
//
import Foundation
import CoreData

struct TrackerCategoryStoreUpdate{
    let insertedCategoryIndexes: [IndexPath]
    let updatedCategoryIndexes: [IndexPath]
}

protocol TrackerCategoryStoreDelegate: AnyObject{
    func stote(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate)
}

final class TrackerCategoryStore: NSObject{
    private let manager = CDManager.shared
    weak var trackerStore: TrackerStore?
    private let context: NSManagedObjectContext
    private var insertedIndexes : [IndexPath] = []
    private var updatedIndexes: [IndexPath] = []
    var fetchedResultsController:NSFetchedResultsController<TrackerCategoryCoreData>
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
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
              let categories = try? objects.map({try self.category(from: $0)}) else {
            return []}
        return categories
    }
    
    func category(from categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory{
        guard let title = categoryCoreData.title else { print(1)
            fatalError()}
        guard let trackerStore = self.trackerStore else { print(2)
            fatalError()}
        guard let trackersCD = categoryCoreData.trackers?.allObjects as? [TrackerCoreData] else {print(3)
            fatalError()}
        guard let trackers = try? trackersCD.map({try trackerStore.tracker(from: $0)}) else { print(4)
            fatalError()
        }
//        guard let title = categoryCoreData.title,
//              let trackerStore = self.trackerStore,
//              let trackersCD = categoryCoreData.trackers?.allObjects as? [TrackerCoreData],
//              let trackers = try? trackersCD.map({try trackerStore.tracker(from: $0)}) else {
//            fatalError()
//        }
        let category = TrackerCategory(title: title, trackerList: trackers)
        return category
    }
    
    func deleteCategory(categoryName: String){
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", categoryName)
        
        do {
            let categoriesToDelete = try context.fetch(fetchRequest)
            for categ in categoriesToDelete{
                context.delete(categ)
            }
            manager.saveContext()
        }catch{
            fatalError(error.localizedDescription)
        }
    }
    
    func newCategory(categoryName: String,trackers: [Tracker] = [] ){
        let category = TrackerCategoryCoreData(context: context)
        if trackers.isEmpty{
            category.title = categoryName
            category.trackers = nil
            
            manager.saveContext()
        }else{
            guard let trackerStore = self.trackerStore else { fatalError() }
            let trackersCD = trackers.compactMap{trackerStore.getTrackerCD(from:$0,categoryName:categoryName)}
            category.title = categoryName
            category.trackers = NSSet(array: trackersCD)
//            manager.saveContext()

            do {
                   try context.save()
               } catch {
                   print("Ошибка сохранения контекста: \(error)")
               }
        }
//        print("Категория создана")
//        manager.saveContext()
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
            guard let trackerStore = self.trackerStore,
                let trackersCD = trackerStore.getTrackerCD(from: tracker, categoryName: categoryName) else {fatalError()}
            print(tracker)
            print(trackersCD)
            category.addToTrackers(trackersCD)
            manager.saveContext()
        }catch{
            fatalError()
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        insertedIndexes = []
        updatedIndexes = []
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert{
            guard let insertedIndexPath = newIndexPath else {fatalError()}
            insertedIndexes.append(insertedIndexPath)
            return
        }
        if type == .update{
            guard let updatedIndexPath = indexPath else {fatalError()}
            updatedIndexes.append(updatedIndexPath)
            return
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        print("controllerDidChangeContent вызван")
        delegate?.stote(self, didUpdate: TrackerCategoryStoreUpdate(insertedCategoryIndexes: insertedIndexes, updatedCategoryIndexes: updatedIndexes))
        insertedIndexes = []
        updatedIndexes = []
    }
}

extension TrackerCategoryStore: TrackerCategoryStoreProtocol{
    var numberOfSections: Int{
//        return categories.count
        guard let count = fetchedResultsController.fetchedObjects?.count else {fatalError()}
        return count
    }
    var categoriesCount: Int{
        guard let count = fetchedResultsController.fetchedObjects?.count else {fatalError()}
        return count
    }
    var isEmpty: Bool{
        guard let isEmpty = fetchedResultsController.fetchedObjects?.isEmpty else {fatalError()}
        return isEmpty
    }
    func makeNewCategory(categoryName: String, trackers: [Tracker] = []) {
        self.newCategory(categoryName: categoryName, trackers: trackers)
    }
    
    func setTrackerStore(trackerStore: TrackerStore){
        self.trackerStore = trackerStore
    }
    func getCategoryName(section: Int) -> String {
        return categories[section].title
    }
    
    func getCategoryCountByIndex(index: Int) -> Int{
        return categories[index].trackerList.count
    }
    
    func getTrackerByIndexPath(index: IndexPath) -> Tracker{
        return categories[index.section].trackerList[index.row]
    }
}
