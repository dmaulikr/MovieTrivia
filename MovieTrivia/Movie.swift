//
//  Movie.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 11/13/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import Foundation

struct Movie {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    var title: String
    var releaseDate: String?
    var releaseYear: String?
    var cast: [String]
    var posterPath: String?
    var idNumber: Int
    
    //----------------------------------
    // MARK: Initialization
    //----------------------------------
    
    init(dictionary: [String: AnyObject]) {
        
        title = dictionary["title"] as! String
        releaseDate = dictionary["release_date"] as? String
        cast = [String]()
        posterPath = dictionary["poster_path"] as? String
        idNumber = dictionary["id"] as! Int
        
        if let date = releaseDate {
            guard date != "" else {return}
            let index = date.index(date.startIndex, offsetBy: 4)
            releaseYear = date.substring(to: index)
        }
    }
    
    //----------------------------------
    // MARK: Helper
    //----------------------------------
    
    static func moviesFromResults(results: [[String: AnyObject]]) -> [Movie] {
        
        var movies = [Movie]()
        
        for result in results {
            movies.append(Movie(dictionary: result))
        }
        
        return movies
    }
}
