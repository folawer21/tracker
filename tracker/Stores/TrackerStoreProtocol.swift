//
//  TrackerStoreProtocol.swift
//  tracker
//
//  Created by Александр  Сухинин on 07.06.2024.
//

import Foundation

protocol TrackerStoreProtocol: AnyObject{
    func numberOfRowsInSection(_ section: Int) -> Int
    func object(at indexPath: IndexPath) -> Tracker?
    func addTracker(_ tracker: Tracker,category: String)
    var isEmpty: Bool {get}
}
