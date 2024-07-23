//
//  UserDefaultsGetter.swift
//  tracker
//
//  Created by Александр  Сухинин on 13.07.2024.
//

import Foundation

final class UserDefaultsGetter{
    static let shared = UserDefaultsGetter()
    
    var skip: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "skip")
        }
    }
    
    func setSkip(skip: Bool){
        UserDefaults.standard.setValue(skip, forKey: "skip")
    }
}
