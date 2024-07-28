//
//  trackerScreenshotsTests.swift
//  trackerScreenshotsTests
//
//  Created by Александр  Сухинин on 23.07.2024.
//

import XCTest
import  SnapshotTesting
@testable import tracker

final class trackerScreenshotsTests: XCTestCase {

    func test_MainViewWithStub() {
        let vc = TrackerViewController()
        //Что скриншот упал надо менять не просто backgroundView у view, а backgroundView у stubView:
        //stubView.backgroundColor = .black
        assertSnapshot(matching: vc,  as: .image)
    }
    
    func test_MainViewWithTrackes() {
        let vc = TrackerViewController()
        assertSnapshot(matching: vc, as: .image)
    }

}
