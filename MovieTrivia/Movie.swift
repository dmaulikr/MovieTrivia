//
//  Movie.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 11/13/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import Foundation
import CoreData

class Movie: NSManagedObject {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    @NSManaged var title: String
    @NSManaged var releaseDate: String?
    @NSManaged var releaseYear: String?
    @NSManaged var posterPath: String?
    @NSManaged var idNumber: Int
    @NSManaged var imageData: Data?
    @NSManaged var cast: Set<Actor>?
    
    //----------------------------------
    // MARK: Initialization
    //----------------------------------
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)!
        super.init(entity: entity, insertInto: context)
        
        title = dictionary["title"] as! String
        releaseDate = dictionary["release_date"] as? String
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
    
    static func moviesFromResults(results: [[String: AnyObject]], context: NSManagedObjectContext) -> [Movie] {
        
        var movies = [Movie]()
        
        for result in results {
            movies.append(Movie(dictionary: result, context: context))
        }
        
        return movies
    }
}
