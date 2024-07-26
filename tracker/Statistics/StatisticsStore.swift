//
//  StatisticsStore.swift
//  tracker
//
//  Created by Александр  Сухинин on 23.07.2024.
//

import Foundation

final class StatisticsStore {
    let trackerRecordStore: TrackerRecordStore
    init() {
        trackerRecordStore = TrackerRecordStore()
    }
    var isEmpty: Bool {
        trackerRecordStore.isEmptyRecords()
    }
    func getBestPeriod() -> Int {
        return trackerRecordStore.maxSequenceOfPerfectDays()
    }
    func getPerfectDaysCount() -> Int {
        return trackerRecordStore.countPerfectDays()
    }
    func getCompletedTrackersCount() -> Int {
        return trackerRecordStore.getAllCompletedTrackers()
    }
    func getMeanValue() -> Float {
        return trackerRecordStore.getMeanTrackersRecordCounts()
    }
}
