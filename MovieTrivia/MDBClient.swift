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

// Image Size Options

enum ImageSize: String {
    case small = "w45"
    case large = "w342"
}

// Error Message Options

enum ErrorMessage: String {
    case cancelled
    case failed
    case missingKey
    case unableToParse
    case missingImagePath
    case noImageData
    case unableToRenderImage
    case repeatSelection
    case dropdownMenu
}

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
    let baseImageURL = "https://image.tmdb.org/t/p/"
    let apiKeyDefault = "af7c170463ea56b4a5142fc83ba863ba"
    let languageDefault = "en-US"
    let includeAdultDefault = "false"
    
    var baseParameters: [String: String] { return
        [apiKey: apiKeyDefault,
        language: languageDefault,
        includeAdult: includeAdultDefault]
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    
    //----------------------------------
    // MARK: API Methods
    //----------------------------------
    
    func searchDatabase(queryInput: String, queryType: String, completionHandler: @escaping (_ movies: [Movie]?, _ actors: [Actor]?, _ errorMessage: ErrorMessage?) -> Void) {
        
        // Cancel any database queries still in progress.
        
        Alamofire.SessionManager.default.session.getAllTasks() { tasks in
            
            for task in tasks {
                guard let url = task.originalRequest?.url else {continue}
                if url.path.contains("search/") {
                    task.cancel()
                }
            }
        }
        
        var params = baseParameters
        params[query] = queryInput
        
        Alamofire.request(baseURL + "search/" + queryType, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
                
            case .failure(let error):
                if error.localizedDescription == "cancelled" {
                    completionHandler(nil, nil, ErrorMessage.cancelled)
                } else {
                    completionHandler(nil, nil, ErrorMessage.failed)
                }
                return
            
            case .success:
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    completionHandler(nil, nil, ErrorMessage.unableToParse)
                    return
                }
                
                if queryType == MDBClient.movie {
                    
                    if let movieData = responseJSON["results"] as? [[String: AnyObject]] {
                        let movies = Movie.moviesFromResults(results: movieData, context: self.sharedContext)
                        completionHandler(movies, nil, nil)
                    } else {
                        completionHandler(nil, nil, ErrorMessage.missingKey)
                    }
                    
                } else {
                    
                    if let actorData = responseJSON["results"] as? [[String: AnyObject]] {
                        let actors = Actor.peopleFromResults(results: actorData, context: self.sharedContext)
                        completionHandler(nil, actors, nil)
                    } else {
                        completionHandler(nil, nil, ErrorMessage.missingKey)
                    }
                }
            }
        }
    }
    
    func getCast(movie: Movie, completionHandler: @escaping (_ result: Set<Actor>?, _ errorMessage: ErrorMessage?) -> Void) {
        
        Alamofire.request(baseURL + "movie/" + String(movie.idNumber.intValue) + "/credits", method: .get, parameters: baseParameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
                
            case .failure:
                completionHandler(nil, ErrorMessage.failed)
                return
                
            case .success:
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    completionHandler(nil, ErrorMessage.unableToParse)
                    return
                }
                
                if let castData = responseJSON["cast"] as? [[String: AnyObject]] {
                    let cast = Actor.peopleFromResults(results: castData, context: self.sharedContext)
                    let castSet = Set(cast)
                    completionHandler(castSet, nil)
                } else {
                    completionHandler(nil, ErrorMessage.missingKey)
                }
            }
        }
    }
    
    func getFilmography(actor: Actor, completionHandler: @escaping (_ result: Set<Movie>?, _ errorMessage: ErrorMessage?) -> Void) {
        
        Alamofire.request(baseURL + "person/" + String(actor.idNumber.intValue) + "/movie_credits", method: .get, parameters: baseParameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
                
            case .failure:
                completionHandler(nil, ErrorMessage.failed)
                return
                
            case .success:
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    completionHandler(nil, ErrorMessage.unableToParse)
                    return
                }
                
                if let filmographyData = responseJSON["cast"] as? [[String: AnyObject]] {
                    let filmography = Movie.moviesFromResults(results: filmographyData, context: self.sharedContext)
                    let filmographySet = Set(filmography)
                    completionHandler(filmographySet, nil)
                } else {
                    completionHandler(nil, ErrorMessage.missingKey)
                }
            }
        }
    }
    
    func getMovieImage(movie: Movie, size: ImageSize, completionHandler: @escaping (_ image: UIImage?, _ errorMessage: ErrorMessage?) -> Void) {
        
        guard let posterPath = movie.posterPath else {
            completionHandler(nil, ErrorMessage.missingImagePath)
            return
        }
        
        Alamofire.request(baseImageURL + size.rawValue + posterPath, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { response in
            
            switch response.result {
                
            case .failure:
                completionHandler(nil, ErrorMessage.failed)
                return
                
            case .success:
                guard let data = response.result.value else {
                    completionHandler(nil, ErrorMessage.noImageData)
                    return
                }
                
                movie.imageData = data
                
                guard let moviePosterImage = UIImage(data: data) else {
                    completionHandler(nil, ErrorMessage.unableToRenderImage)
                    return
                }
                
                completionHandler(moviePosterImage, nil)
            }
        }
    }
    
    func getActorImage(actor: Actor, size: ImageSize, completionHandler: @escaping (_ image: UIImage?, _ errorMessage: ErrorMessage?) -> Void) {
        
        guard let profilePath = actor.profilePath else {
            completionHandler(nil, ErrorMessage.missingImagePath)
            return
        }
        
        Alamofire.request(baseImageURL + size.rawValue + profilePath, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { response in
            
            switch response.result {
                
            case .failure:
                completionHandler(nil, ErrorMessage.failed)
                return
                
            case .success:
                guard let data = response.result.value else {
                    completionHandler(nil, ErrorMessage.noImageData)
                    return
                }
                
                actor.imageData = data
                
                guard let actorImage = UIImage(data: data) else {
                    completionHandler(nil, ErrorMessage.unableToRenderImage)
                    return
                }
                
                completionHandler(actorImage, nil)
            }
        }
    }
}
