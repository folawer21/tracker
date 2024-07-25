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
    weak var trackerRecord: TrackerRecordStore?
    private let context: NSManagedObjectContext
    var filter: Filtres = .all
    private var insertedIndexes : [IndexPath] = []
    private var updatedIndexes: [IndexPath] = []
    private var searchText: String = ""
    var date: Date
    var day: WeekDay
    var fetchedResultsController:NSFetchedResultsController<TrackerCategoryCoreData>
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var categories: [TrackerCategory]{
        guard let objects = self.fetchedResultsController.fetchedObjects,
              let categories = try? objects.map({try self.category(from: $0)}) else {
            return []}
        return categories
    }
   
    var filteredCategories: [TrackerCategory]{
        if !searchText.isEmpty {
            return categories.filter { $0.title.lowercased().contains(searchText.lowercased()) && $0.trackerList.contains(where: {$0.timetable.contains(self.day)})}
        } else {
            switch filter {
            case .all:
                print("filter: ",filter)
                return categories.filter({$0.trackerList.isEmpty == false && $0.trackerList.contains(where: {$0.timetable.contains(self.day)})})
            case .today:
                print("filter: ",filter)
                return categories.filter({$0.trackerList.isEmpty == false && $0.trackerList.contains(where: {$0.timetable.contains(self.day)})})
            case .completed:
                print("filter: ",filter)
                return categories.filter({$0.trackerList.isEmpty == false && $0.trackerList.contains(where: {$0.timetable.contains(self.day) && trackerRecord?.isRecordedByDate(id: $0.id, date: date) == true})})
            case .uncompleted:
                print("filter: ",filter)
                return categories.filter({$0.trackerList.isEmpty == false && $0.trackerList.contains(where: {$0.timetable.contains(self.day) && trackerRecord?.isRecordedByDate(id: $0.id, date: date) == false})})
            }
        }
    }
    
    init(day: WeekDay,date: Date){
        self.context = manager.context
        self.day = day
        self.date = date
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

            do {
                   try context.save()
               } catch {
                   print("Ошибка сохранения контекста: \(error)")
               }
        }
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
        delegate?.stote(self, didUpdate: TrackerCategoryStoreUpdate(insertedCategoryIndexes: insertedIndexes, updatedCategoryIndexes: updatedIndexes))
        insertedIndexes = []
        updatedIndexes = []
    }
}

extension TrackerCategoryStore: TrackerCategoryStoreProtocol{
    var numberOfSections: Int{
        //        guard let count = fetchedResultsController.fetchedObjects?.count else {fatalError()}
        //        return count
        filteredCategories.count
    }
    var categoriesCount: Int{
        //        guard let count = fetchedResultsController.fetchedObjects?.count else {fatalError()}
        //        return count
        categories.count
    }
    var isEmpty: Bool{
        //        guard let isEmpty = fetchedResultsController.fetchedObjects?.isEmpty else {fatalError()}
        //        return isEmpty
        filteredCategories.isEmpty
    }
    func makeNewCategory(categoryName: String, trackers: [Tracker] = []) {
        self.newCategory(categoryName: categoryName, trackers: trackers)
    }
    
    func setTrackerStore(trackerStore: TrackerStore){
        self.trackerStore = trackerStore
    }
    func getCategoryName(section: Int) -> String {
        //        return categories[section].title
        return filteredCategories[section].title
    }
    func getCategoryNameVC(section: Int) -> String {
        //        return categories[section].title
        return categories[section].title
    }
    
    
    func getCategoryCountByIndex(index: Int) -> Int{
        switch filter {
        case .all:
            print("filter: ",filter,"day: ",day)
            return filteredCategories[index].trackerList.filter({$0.timetable.contains(self.day)}).count
        case .today:
            print("filter: ",filter,"day: ",day)
            return filteredCategories[index].trackerList.filter({$0.timetable.contains(self.day)}).count
        case .completed:
            print("filter: ",filter,"day: ",day)
            return filteredCategories[index].trackerList.filter({trackerRecord?.isRecordedByDate(id: $0.id, date: date) == true && $0.timetable.contains(self.day)}).count
        case .uncompleted:
            print("filter: ",filter,"day: ",day)
            return filteredCategories[index].trackerList.filter({trackerRecord?.isRecordedByDate(id: $0.id, date: date) == false && $0.timetable.contains(self.day)}).count
        }
        //        return categories[index].trackerList.count
//        return filteredCategories[index].trackerList.filter({$0.timetable.contains(self.day)}).count
    }
    
    func getTrackerByIndexPath(index: IndexPath) -> Tracker{
        //        return categories[index.section].trackerList[index.row]
        switch filter {
        case .all:
            return filteredCategories[index.section].trackerList[index.row]
        case .today:
            return filteredCategories[index.section].trackerList[index.row]
        case .completed:
            return filteredCategories[index.section].trackerList.filter({trackerRecord?.isRecordedByDate(id: $0.id, date: date) == true })[index.row]
        case .uncompleted:
            return filteredCategories[index.section].trackerList.filter({trackerRecord?.isRecordedByDate(id: $0.id, date: date) == false })[index.row]
        }
//        return filteredCategories[index.section].trackerList/*.filter({$0.timetable.contains(self.day)})*/ [index.row]
    }
    
    func updateCategoriesWithSearch(searchText: String){
        self.searchText = searchText
    }
    
    func getCategoryNameById(by trackerId: UUID) -> String? {
        let firstCategory = categories.first(where: {
            $0.trackerList.contains(where: {$0.id == trackerId})
        })
        return firstCategory?.title
    }
    
    func pin(trackerId: UUID) {
        guard let tracker = trackerStore?.getTrackerById(id: trackerId),
              let categoryName = getCategoryNameById(by: trackerId) else {return}
        trackerStore?.deleteTracker(id: tracker.id)
        UserDefaults.standard.setValue(categoryName, forKey: tracker.id.uuidString)
        addTrackerToCategory(tracker: tracker, categoryName: NSLocalizedString("category_pinned", comment: ""))
    }
    
    func unpin(trackerId: UUID) {
        guard let tracker = trackerStore?.getTrackerById(id: trackerId) else {return}
        trackerStore?.deleteTracker(id: tracker.id)
        guard let category = UserDefaults.standard.string(forKey: tracker.id.uuidString) else {return }
        addTrackerToCategory(tracker: tracker, categoryName: category)
    }
    
    func isPinnedById(trackerId: UUID) -> Bool {
        guard let category = categories.first(where: {$0.title == NSLocalizedString("category_pinned", comment: "")}) else { return false }
        guard let firstIndex = category.trackerList.first(where: {$0.id == trackerId}) else { return false}
        return true
    }
    
    func setFilter(filter: Filtres) {
        self.filter = filter
    }
    func setDay(day: WeekDay) {
        self.day = day
    }
    func setDate(date: Date) {
        self.date = date
    }
    
    func setRecordStore(recordStore: TrackerRecordStore) {
        self.trackerRecord = recordStore
    }
}
