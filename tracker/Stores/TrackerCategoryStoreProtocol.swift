//
//  TrackerCategoryStoreProtocol.swift
//  tracker
//
//  Created by Александр  Сухинин on 07.06.2024.
//

import Foundation

protocol TrackerCategoryStoreProtocol: AnyObject{
    var numberOfSections: Int {get}
    func makeNewCategory(categoryName: String,trackers: [Tracker])
    func getCategoryName(section: Int) -> String
    
}
