//
//  Game.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 12/1/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import Foundation
import CoreData

class Game: NSManagedObject {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    @NSManaged var players: [Player]
    @NSManaged var history: [Turn]
    
    //----------------------------------
    // MARK: Initialization
    //----------------------------------
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Game", in: context)!
        super.init(entity: entity, insertInto: context)
    }
}
