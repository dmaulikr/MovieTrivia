//
//  Actor.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 11/14/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import Foundation
import CoreData

class Actor: NSManagedObject {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    @NSManaged var name: String
    @NSManaged var profilePath: String?
    @NSManaged var idNumber: NSNumber
    @NSManaged var imageData: Data?
    @NSManaged var filmography: Set<Movie>?
    
    //----------------------------------
    // MARK: Initialization
    //----------------------------------
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Actor", in: context)!
        super.init(entity: entity, insertInto: context)
        
        name = dictionary["name"] as! String
        profilePath = dictionary["profile_path"] as? String
        idNumber = dictionary["id"] as! NSNumber
    }
    
    //----------------------------------
    // MARK: Helper
    //----------------------------------
    
    static func peopleFromResults(results: [[String: AnyObject]], context: NSManagedObjectContext) -> [Actor] {
        
        var people = [Actor]()
        
        for result in results {
            people.append(Actor(dictionary: result, context: context))
            
        }
        
        return people
    }
}
