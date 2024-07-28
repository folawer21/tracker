//
//  AnalyticsService.swift
//  tracker
//
//  Created by Александр  Сухинин on 28.07.2024.
//

import Foundation
import YandexMobileMetrica

enum Events: String {
    case open
    case close
    case click
}

enum Screens: String {
    case main
    case category
}

enum EventItems: String {
    case addTrack
    case track
    case filter
    case edit
    case delete
}

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "e97b0212-b480-487f-aa4b-c9684831b59f") else { return }
        YMMYandexMetrica.activate(with: configuration)
    }

    func report(event: Events, screen: Screens , item: EventItems? = nil) {
        let params = ["screen" : screen.rawValue , "item" : item?.rawValue]
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
