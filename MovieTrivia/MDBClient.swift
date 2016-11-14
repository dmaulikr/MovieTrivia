//
//  MDBClient.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 11/11/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import Foundation
import Alamofire

struct MDBClient {
    
    //----------------------------------
    // MARK: Constants
    //----------------------------------
    
    // Parameter Keys
    
    let apiKey = "api_key"
    let language = "language"
    let includeAdult = "include_adult"
    let query = "query"
    
    // Query Types
    
    static let movie = "movie"
    static let person = "person"
    
    // Default Parameters
    
    let baseURL = "https://api.themoviedb.org/3/search/"
    let apiKeyDefault = "af7c170463ea56b4a5142fc83ba863ba"
    let languageDefault = "en-US"
    let includeAdultDefault = "false"
    
    var baseParameters: [String: String] { return
        [apiKey: apiKeyDefault,
        language: languageDefault,
        includeAdult: includeAdultDefault]
    }
    
    //----------------------------------
    // MARK: API Methods
    //----------------------------------
    
    func searchDatabase(queryInput: String, queryType: String, completionHandler: @escaping (_ result: [Movie]?, _ error: NSError?) -> Void) {
        
        var params = baseParameters
        params[query] = queryInput
        
        Alamofire.request(baseURL + queryType, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            guard response.result.isSuccess else {
                // TODO: Handle error.
                print("MDBClient: Movie query was unsuccessful.")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                // TODO: Handle error.
                print("MDBClient: Unable to parse Movie response.")
                return
            }
            
            if let movieData = responseJSON["results"] as? [[String: AnyObject]] {
                let movies = Movie.moviesFromResults(results: movieData)
                completionHandler(movies, nil)
            } else {
                // TODO: Handle error.
                print("MDBClient: Nothing found for 'results' key.")
            }
        }
    }
}
