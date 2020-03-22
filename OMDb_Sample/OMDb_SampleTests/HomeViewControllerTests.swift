//
//  HomeViewControllerTests.swift
//  OMDb_SampleTests
//
//  Created by Pavitra Hegde on 22/03/20.
//  Copyright © 2020 Pavitra Hegde. All rights reserved.
//

import XCTest
@testable import OMDb_Sample

class HomeViewControllerTests: XCTestCase {

    var vcMock: HomeViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vcMock = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        _ = vcMock.view
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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

}
