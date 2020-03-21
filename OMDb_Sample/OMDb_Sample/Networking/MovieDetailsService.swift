//
//  MovieDetailsService.swift
//  OMDb_Sample
//
//  Created by Pavitra Hegde on 21/03/20.
//  Copyright © 2020 Pavitra Hegde. All rights reserved.
//

import Foundation

class MovieSearchService {
    
    static let sharedService = MovieSearchService()
    
    private init() {
        
    }
    
    private var session: URLSession {
        let sessionCongig: URLSessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionCongig, delegate: nil, delegateQueue: .main)
        return session
    }
    
    func sendSearchRequest(with text: String, page: Int, completion: @escaping ((_ response: SearchResponse?,_ error: Error?) -> Void)) {
        
        let urlString = Constants.baseUrl + "?s=\(text)&apikey=\(Constants.apiKey)&page=\(page)"
        let url = URL(string: urlString)!
        let task = session.dataTask(with: url) { (data, response, error) in
            let jsonParser = JSONParser(data: data, response: response, error: error)
            
            do {
                let result = try jsonParser.parse(type: SearchResponse.self)
                completion(result, error)
            } catch {
                completion(nil,error)
            }
        }
        task.resume()
    }
    
}
