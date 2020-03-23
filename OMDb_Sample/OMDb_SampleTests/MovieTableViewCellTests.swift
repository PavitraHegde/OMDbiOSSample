//
//  MovieTableViewCellTests.swift
//  OMDb_SampleTests
//
//  Created by Pavitra Hegde on 23/03/20.
//  Copyright © 2020 Pavitra Hegde. All rights reserved.
//

import XCTest
@testable import OMDb_Sample

class MovieTableViewCellTests: XCTestCase {
    
    var mockCell: MovieTableViewCell!
    
    let result = SearchResult(title: "abc", year: "1991", imdbID: "tt11199474", type: "movie", poster: URL(string: "http://abc")!)
    
    
    override func setUp() {
        let tableView = UITableView()
        let identifier = "SearchMusicTableViewCell"
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        mockCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as! MovieTableViewCell)
        
    }
    
    func testConfigureCellWhenResultIsNotNil() {
        mockCell.configureCell(with: result)
        XCTAssertEqual(mockCell.movieTitle.text, result.title)
        XCTAssertEqual(mockCell.movieReleaseYear.text, result.year)
        XCTAssertEqual(mockCell.type.text, result.type)
        XCTAssertEqual(mockCell.type.alpha,1)
        XCTAssertEqual(mockCell.movieTitle.alpha,1)
        XCTAssertEqual(mockCell.movieReleaseYear.alpha,1)
    }
    
    func testConfigureCellWhenResultIsNil() {
        mockCell.configureCell(with: nil)
        XCTAssertEqual(mockCell.type.alpha,0)
        XCTAssertEqual(mockCell.movieTitle.alpha,0)
        XCTAssertEqual(mockCell.movieReleaseYear.alpha,0)
    }
    
    
}
