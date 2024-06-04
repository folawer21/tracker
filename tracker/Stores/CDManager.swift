//
//  CDManager.swift
//  tracker
//
//  Created by Александр  Сухинин on 04.06.2024.
//

import Foundation
import CoreData


final class CDManager{
    
    static let shared = CDManager()
    
    var context: NSManagedObjectContext{
        persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?{
                fatalError()
            }
        })
        return container
    }()
    
    
    func saveContext(){
        if context.hasChanges{
            do{
                try context.save()
            }catch{
                context.rollback()
                fatalError("Problems with context")
            }
        }
    }
}
