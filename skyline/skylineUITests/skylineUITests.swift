//
//  skylineUITests.swift
//  skylineUITests
//
//  Created by Sammy Franusic on 9/25/20.
//  Copyright © 2020 sf. All rights reserved.
//

import XCTest

class skylineUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainViewIsPresent() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let mainView = app.otherElements["mainView"]
        XCTAssert(mainView.isHittable, "Main view should be hittable after launching application.")
    }

    func testSwiping() throws {
        let app = XCUIApplication()
        app.launch()
        let mainView = app.otherElements["mainView"]
        for _ in 1...3 {
            mainView.swipeUp()
        }
        XCTAssert(mainView.isHittable, "Main view should be hittable after launching application and swiping.")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
