//
//  Person.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 11/14/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    @NSManaged var name: String
    @NSManaged var profilePath: String?
    @NSManaged var idNumber: Int
    @NSManaged var imageData: Data?
    @NSManaged var filmography: [Movie]
    
    //----------------------------------
    // MARK: Initialization
    //----------------------------------
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)!
        super.init(entity: entity, insertInto: context)
        
        name = dictionary["name"] as! String
        profilePath = dictionary["profile_path"] as? String
        idNumber = dictionary["id"] as! Int
    }
    
    //----------------------------------
    // MARK: Helper
    //----------------------------------
    
    static func peopleFromResults(results: [[String: AnyObject]], context: NSManagedObjectContext) -> [Person] {
        
        var people = [Person]()
        
        for result in results {
            people.append(Person(dictionary: result, context: context))
        }
        
        return people
    }
}
