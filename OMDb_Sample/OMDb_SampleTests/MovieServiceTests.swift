//
//  MovieServiceTests.swift
//  OMDb_SampleTests
//
//  Created by Pavitra Hegde on 23/03/20.
//  Copyright © 2020 Pavitra Hegde. All rights reserved.
//

import XCTest
@testable import OMDb_Sample

class MovieServiceTests: XCTestCase {
    
    var movieDataService: MovieSearchService!
    
    override func setUp() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: .main)
        movieDataService = MovieSearchService(session: session)
    }
    
    func testSearchAPIResponseSuccess() {
        let text = "kabhi"
        let page = 2
        let urlString = Constants.baseUrl + "?s=\(text)&apikey=\(Constants.apiKey)&page=\(page)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let expectedURL = URL(string: encodedString)!
        let data = JSONParser.getJSONData(fileName: "searchresponse")
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == expectedURL else {
                throw ServiceError.invalidRequest
            }
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        let expectation = XCTestExpectation(description: "Movie Search Success Response")
        movieDataService.sendSearchRequest(with: text, page: page) { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            XCTAssertEqual(response?.results.count, 10)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 60)
    }
    
    func testSearchAPIResponseFail() {
        let text = ""
        let page = 2
        let urlString = Constants.baseUrl + "?s=\(text)&apikey=\(Constants.apiKey)&page=\(page)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let expectedURL = URL(string: encodedString)!
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == expectedURL else {
                throw ServiceError.invalidRequest
            }
            let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        let expectation = XCTestExpectation(description: "Movie Search Failure Response")
        movieDataService.sendSearchRequest(with: text, page: page) { (response, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(response)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 60)
    }
    
    func testGetDetailsAPIResponseSuccess() {
        let id = "tt11199474"
        let urlString = Constants.baseUrl + "?i=\(id)&apikey=\(Constants.apiKey)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let expectedURL = URL(string: encodedString)!
        let data = JSONParser.getJSONData(fileName: "searchdetails")
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == expectedURL else {
                throw ServiceError.invalidRequest
            }
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
         let expectation = XCTestExpectation(description: "Movie SearchDetails Success Response")
        
        movieDataService.getDetails(with: id) { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 60)
    }
    
    func testGetDetailsAPIResponseFailure() {
        let id = ""
        let urlString = Constants.baseUrl + "?i=\(id)&apikey=\(Constants.apiKey)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let expectedURL = URL(string: encodedString)!
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == expectedURL else {
                throw ServiceError.invalidRequest
            }
            let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        let expectation = XCTestExpectation(description: "Movie SearchDetails Failure Response")
        
        movieDataService.getDetails(with: id) { (response, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(response)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 60)
    }
    
}
