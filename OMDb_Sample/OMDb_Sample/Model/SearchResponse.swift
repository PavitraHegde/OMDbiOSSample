//
//  SearchMovie.swift
//  OMDb_Sample
//
//  Created by Pavitra Hegde on 20/03/20.
//  Copyright © 2020 Pavitra Hegde. All rights reserved.
//

import Foundation

// MARK: - SearchMovie
struct SearchResponse: Codable {
    var results: [SearchResult]
    private let totalResults: String
    let response: String
    var totalCount: Int {
       return Int(totalResults) ?? 0
    }

    enum CodingKeys: String, CodingKey {
        case results = "Search"
        case totalResults
        case response = "Response"
    }
    
    init(results: [SearchResult], totalResults: String, response: String) {
        self.results = results
        self.totalResults = totalResults
        self.response = response
    }
}

// MARK: - Search
struct SearchResult: Codable {
    let title, year, imdbID: String
    let type: String
    let poster: URL

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
