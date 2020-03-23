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
    var spinner = UIActivityIndicatorView(style: .medium)
    var searchResponse: SearchResponse!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vcMock = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        _ = vcMock.view
        
         let searchResult = SearchResult(title: "abc", year: "1991", imdbID: "123", type: "movie", poster: URL(string: "http://abc")!)
           searchResponse = SearchResponse(results: [searchResult], totalResults: "120", response: "true")
        
    }

    func testSpinnerShouldHideWhenStopped() {
        vcMock.initialSetUp()
        XCTAssertEqual(vcMock.spinner.hidesWhenStopped, true)
    }
    
    func testIsSearchResultUpdateSuccess() {
        let searchResult = SearchResult(title: "abc", year: "1991", imdbID: "123", type: "movie", poster: URL(string: "http://abc")!)
        let searchResponse1 = SearchResponse(results: [searchResult], totalResults: "120", response: "true")
        let searchResponse2 = SearchResponse(results: [searchResult], totalResults: "120", response: "true")
        vcMock.searchResponse = searchResponse1
        XCTAssertEqual(vcMock.searchResults.count, searchResponse1.results.count)
        vcMock.searchResponse = searchResponse2
        XCTAssertEqual(vcMock.searchResults.count,(searchResponse1.results + searchResponse2.results).count)
        vcMock.searchResponse = nil
        XCTAssertEqual(vcMock.searchResults.count, 0)
    }
    
    func testNumberOfRowsInSectionOfTableView() {
        vcMock.searchResponse = searchResponse
        let value = vcMock.tableView(vcMock.tableView, numberOfRowsInSection: 1)
        XCTAssertEqual(value,vcMock.searchResponse!.totalCount)
    }
    
    func testConfigureTableViewCell() {
         let cell = vcMock.tableView(vcMock.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is MovieTableViewCell)
    }
    
    func testParamOnSearchBarSearchButtonClicked() {
        let searchBar = UISearchBar()
        searchBar.text = "search"
        vcMock.searchBarSearchButtonClicked(searchBar)
        XCTAssertFalse(searchBar.text!.count < 3)
        XCTAssertEqual(vcMock.searchController.isActive, false)
        XCTAssertNil(vcMock.searchResponse)
        XCTAssertEqual(vcMock.searchText, searchBar.text)
    }
    
}
