//
//  MDBClient.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 11/11/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

struct MDBClient {
    
    //----------------------------------
    // MARK: Properties
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
    
    let baseURL = "https://api.themoviedb.org/3/"
    let apiKeyDefault = "af7c170463ea56b4a5142fc83ba863ba"
    let languageDefault = "en-US"
    let includeAdultDefault = "false"
    
    var baseParameters: [String: String] { return
        [apiKey: apiKeyDefault,
        language: languageDefault,
        includeAdult: includeAdultDefault]
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    //----------------------------------
    // MARK: API Methods
    //----------------------------------
    
    func searchDatabase(queryInput: String, queryType: String, completionHandler: @escaping (_ movies: [Movie]?, _ actors: [Person]?, _ error: NSError?) -> Void) {
        
        var params = baseParameters
        params[query] = queryInput
        
        Alamofire.request(baseURL + "search/" + queryType, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            guard response.result.isSuccess else {
                // TODO: Handle error.
                print("MDBClient: Movie query was unsuccessful.")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                // TODO: Handle error.
                print("MDBClient: Unable to parse movie response.")
                return
            }
            
            if queryType == MDBClient.movie {
                
                if let movieData = responseJSON["results"] as? [[String: AnyObject]] {
                    let movies = Movie.moviesFromResults(results: movieData, context: self.sharedContext)
                    completionHandler(movies, nil, nil)
                } else {
                    // TODO: Handle error.
                    print("MDBClient: Nothing found for 'results' key.")
                }
                
            } else {
                
                if let actorData = responseJSON["results"] as? [[String: AnyObject]] {
                    let actors = Person.peopleFromResults(results: actorData, context: self.sharedContext)
                    completionHandler(nil, actors, nil)
                } else {
                    // TODO: Handle error.
                    print("MDBClient: Nothing found for 'results' key.")
                }
            }
        }
    }
    
    func getCast(movieID: Int, completionHandler: @escaping (_ result: [Person]?, _ error: NSError?) -> Void) {
        
        Alamofire.request(baseURL + "movie/" + String(movieID) + "/credits", method: .get, parameters: baseParameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            guard response.result.isSuccess else {
                // TODO: Handle error.
                print("MDBClient: Cast query was unsuccessful.")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                // TODO: Handle error.
                print("MDBClient: Unable to parse cast response.")
                return
            }
            
            if let castData = responseJSON["cast"] as? [[String: AnyObject]] {
                let cast = Person.peopleFromResults(results: castData, context: self.sharedContext)
                completionHandler(cast, nil)
            } else {
                // TODO: Handle error.
                print("MDBClient: Nothing found for 'cast' key.")
            }
        }
    }
    
    func getFilmography(personID: Int, completionHandler: @escaping (_ result: [Movie]?, _ error: NSError?) -> Void) {
        
        Alamofire.request(baseURL + "person/" + String(personID) + "/movie_credits", method: .get, parameters: baseParameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            guard response.result.isSuccess else {
                // TODO: Handle error.
                print("MDBClient: Filmography query was unsuccessful.")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                // TODO: Handle error.
                print("MDBClient: Unable to parse filmography response.")
                return
            }
            
            if let filmographyData = responseJSON["cast"] as? [[String: AnyObject]] {
                let filmography = Movie.moviesFromResults(results: filmographyData, context: self.sharedContext)
                completionHandler(filmography, nil)
            } else {
                // TODO: Handle error.
                print("MDBClient: Nothing found for 'cast' key (filmography).")
            }
        }
    }
}
