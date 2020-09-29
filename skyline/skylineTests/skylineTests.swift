//
//  skylineTests.swift
//  skylineTests
//
//  Created by Sammy Franusic on 9/25/20.
//  Copyright © 2020 sf. All rights reserved.
//

import XCTest
@testable import skyline

class skylineTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetPhotoURL() throws {
        UnsplashAPI.shared.getPage { page in
            if let page = page {
                let url = URL(string: page.results.first?.urls.small ?? "")
                XCTAssert(url != nil, "Download URL should not be nil.")
            } else {
                XCTAssert(page != nil, "Page response should not be nil.")
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
