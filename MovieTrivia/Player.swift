//
//  Player.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 12/1/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Player: NSManagedObject {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    @NSManaged var name: String
    @NSManaged var color: UIColor?
    @NSManaged var score: Int
    @NSManaged var turns: [Turn]?
    @NSManaged var game: Game?
    
    //----------------------------------
    // MARK: Initialization
    //----------------------------------
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(name: String, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Player", in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.name = name
        self.score = 0
    }
}
