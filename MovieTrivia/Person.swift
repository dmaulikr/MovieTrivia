//
//  Person.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 11/14/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import Foundation

struct Person {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    var name: String
    var profilePath: String?
    var idNumber: Int
    
    //----------------------------------
    // MARK: Initialization
    //----------------------------------
    
    init(dictionary: [String: AnyObject]) {
        
        name = dictionary["name"] as! String
        profilePath = dictionary["profile_path"] as? String
        idNumber = dictionary["id"] as! Int
    }
    
    //----------------------------------
    // MARK: Helper
    //----------------------------------
    
    static func peopleFromResults(results: [[String: AnyObject]]) -> [Person] {
        
        var people = [Person]()
        
        for result in results {
            people.append(Person(dictionary: result))
        }
        
        return people
    }
}
