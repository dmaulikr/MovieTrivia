//
//  InstructionsViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 2/13/17.
//  Copyright © 2017 Theodore Rothrock. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    
    //----------------------------------
    // MARK: Properties & Outlets
    //----------------------------------
    
    var currentPlayer: Player!
    var game: Game!
    
    @IBOutlet weak var instructionsTextView: UITextView!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = currentPlayer.color
        instructionsTextView.backgroundColor = currentPlayer.color
        
        if game.isSinglePlayerGame {
            
            instructionsTextView.text = "1. To start each round, choose a movie or an actor.\n\n2. If you choose a movie, the computer will choose an actor who appeared in that movie. If you choose an actor, the computer will choose a movie in which the actor appeared.\n\n3. For the rest of the round, you can choose either a movie that featured the current actor or an actor who appeared in the current movie. For example, if the current picks are Tom Hanks and \"Toy Story,\" you can choose another movie featuring Tom Hanks or another actor from \"Toy Story.\"\n\n4. Answer incorrectly and the round is over. The object of the game in single-player mode is to beat your high score.\n\n"
            
        } else {
            
            instructionsTextView.text = "1. To start each round, the first player selects a movie or an actor.\n\n2. If the first player chose a movie, the second player must choose an actor who appeared in that movie. If the first player chose an actor, the second player must choose a movie in which the actor appeared.\n\n3. The next player can choose either an actor from the current movie or a movie featuring the current actor. For example, if the current picks are Tom Hanks and \"Toy Story,\" the player can choose another movie featuring Tom Hanks or another actor from \"Toy Story.\"\n\n4. Play continues in this fashion until a player answers incorrectly. An incorrect answer results in a strike. When a player reaches three strikes, they are eliminated from the game. The last remaining player is the winner.\n\n"
        }
    }
    
    override func viewDidLayoutSubviews() {
        instructionsTextView.setContentOffset(CGPoint.zero, animated: false)
    }
}
