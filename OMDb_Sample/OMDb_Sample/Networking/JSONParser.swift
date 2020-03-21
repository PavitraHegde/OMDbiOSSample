//
//  JSONParser.swift
//  OMDb_Sample
//
//  Created by Pavitra Hegde on 21/03/20.
//  Copyright © 2020 Pavitra Hegde. All rights reserved.
//

import Foundation

class JSONParser {
    
    var data:Data?
    var response:URLResponse?
    var error:Error?
    
    private let jsonDecoder = JSONDecoder()
    
    init(data: Data?, response: URLResponse?,error: Error?) {
        self.data = data
        self.response = response
        self.error = error
        
    }
    
    func parse<T:Decodable>(type:T.Type) throws -> T  {
        
        guard let response = response, response.isSuccess else {
            throw ServiceError.unknownError
        }
        guard let data = data else {
            throw ServiceError.noData
        }
        do {
            let result = try jsonDecoder.decode(type, from: data)
            return result
        } catch  {
            throw error
        }
    }
    
}

enum ParseError: Error {
    case responseTypeNotFound
}

enum ServiceError: Error {
    case unknownError
    case noData
    
}

extension URLResponse {
    var httpStatusCode: Int? {
        guard let httpResponse = self as? HTTPURLResponse else {             return nil
        }
        return httpResponse.statusCode
    }
    
    var isSuccess: Bool {
        guard let value = self.httpStatusCode else {
            return false
        }
        switch value {
        case 200 ... 299:
            return true
        default:
            return false
            
        }
        
    }
    
}
