//
//  Turn.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 12/1/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import Foundation
import CoreData

class Turn: NSManagedObject {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    @NSManaged var player: Player
    @NSManaged var success: Bool
    @NSManaged var round: NSNumber
    @NSManaged var movie: Movie?
    @NSManaged var actor: Actor?
    @NSManaged var game: Game
    
    //----------------------------------
    // MARK: Initialization
    //----------------------------------
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(player: Player, game: Game, success: Bool, round: Int, movie: Movie?, actor: Actor?, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Turn", in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.player = player
        self.game = game
        self.success = success
        self.round = NSNumber(value: round)
        self.movie = movie
        self.actor = actor
    }
}
