//
//  DetailViewControllerTests.swift
//  OMDb_SampleTests
//
//  Created by Pavitra Hegde on 23/03/20.
//  Copyright © 2020 Pavitra Hegde. All rights reserved.
//

import XCTest
@testable import OMDb_Sample

class DetailViewControllerTests: XCTestCase {

    var vcMock: DetailViewController!
    var result: MovieDetails!
    
    override func setUp() {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vcMock = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        let recieveData = SearchResult(title: "abc", year: "1991", imdbID: "tt11199474", type: "movie", poster: URL(string: "http://abc")!)
        result = MovieDetails.init(title: "abc", year: "1991", rated: nil, released: nil, runtime: nil, genre: nil, director: nil, writer: nil, actors: "akshay", plot: "this", language: nil, country: nil, awards: nil, poster: URL(string: "http://abc")!, ratings: [], metascore: "N/A", imdbRating: "3.6", imdbVotes:"", imdbID: "123", type: "movie", dvd: nil, boxOffice: nil, production: nil, website: nil, response: "true")
        vcMock.recieveData = recieveData
         _ = vcMock.view
    }

    
    func testUpdateData() {
        vcMock.updateData(result)
        XCTAssertEqual(vcMock.movieTitle.text, result.title)
        
    }
    
}
