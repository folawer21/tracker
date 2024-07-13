//
//  TrackerCoreDataMigrationPolicy.swift
//  tracker
//
//  Created by Александр  Сухинин on 08.06.2024.
//

import CoreData

class TrackerCoreDataMigrationPolicy: NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource sourceInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        let destinationInstance = NSEntityDescription.insertNewObject(forEntityName: mapping.destinationEntityName!, into: manager.destinationContext)
        
        // Преобразование и копирование данных
        if let oldTypeData = sourceInstance.value(forKey: "type") as? NSData {
            if let oldType = try? JSONDecoder().decode(TrackerType.self, from: oldTypeData as Data) {
                let newType = Tracker.typeToJSON(fromType: oldType)  // или другой способ преобразования в строку
                destinationInstance.setValue(newType, forKey: "type")
            }
        }
        
        if let oldTimetableData = sourceInstance.value(forKey: "timetable") as? NSData {
            if let oldTimetable = try? JSONDecoder().decode([WeekDay].self, from: oldTimetableData as Data) {
                let newTimetable =  Tracker.timetableToJSON(fromTimetable: oldTimetable)
                destinationInstance.setValue(newTimetable, forKey: "timetable")
            }
        }
        
        // Копирование остальных атрибутов
        for attribute in mapping.attributeMappings! {
            if attribute.name! == "type" || attribute.name! == "timetable" {
                continue
            }
            
            if let value = sourceInstance.value(forKey: attribute.name! ) {
                destinationInstance.setValue(value, forKey: attribute.name!)
            }
        }
        
        // Сообщите менеджеру миграции о завершении преобразования
        manager.associate(sourceInstance: sourceInstance, withDestinationInstance: destinationInstance, for: mapping)
    }
}
