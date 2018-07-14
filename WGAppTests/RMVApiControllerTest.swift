//
//  RMVApiControllerTest2.swift
//  WGAppTests
//
//  Created by Viviane Rehor on 02.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import XCTest
@testable import WGApp

class RMVApiControllerTest: XCTestCase {
    
    var rmvApiController: RMVApiController!
    
    override func setUp() {
        rmvApiController = RMVApiController()
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        rmvApiController = nil
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_stopLocations() {
        // Create an expectation
        let expectation = self.expectation(description: "Scaling")
        var results = [StopLocationRMV]()
        
        RMVApiController.getStoplocations(withEntryString: "Dreiwei Wi", completion: { articles in
            //filter by wished StopId
            results = articles.filter { $0.id == "003025274" }
            // Fullfil the expectation to let the test runner
            // know that it's OK to proceed
            expectation.fulfill()
        })
        
        // Wait for the expectation to be fullfilled, or time out
        // after 5 seconds. This is where the test runner will pause.
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(results.count==1)
        XCTAssertEqual("WI Dreiweidenstraße", results[0].name)
        
    }
    
    
    func test_departures() {
        // Create an expectation
        let expectation = self.expectation(description: "Scaling")
        var result: Departure? = nil
        
        RMVApiController.getDepartures(fromOriginId: "003025274", completion: { departures in
            //filter by wished StopId
            result = departures[0]
            // Fullfil the expectation to let the test runner
            // know that it's OK to proceed
            expectation.fulfill()
        })
        
        // Wait for the expectation to be fullfilled, or time out
        // after 5 seconds. This is where the test runner will pause.
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual("Wiesbaden Dreiweidenstrasse", result!.stop)
        
    }
    
}


