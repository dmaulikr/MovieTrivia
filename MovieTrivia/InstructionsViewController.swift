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
    
    @IBOutlet weak var instructionsTextView: UITextView!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = currentPlayer.color
        instructionsTextView.backgroundColor = currentPlayer.color
        
        instructionsTextView.text = "1. To start each round, the first player selects a movie or an actor.\n\n2. If the first player chose a movie, the second player must choose an actor who appeared in that movie. If the first player chose an actor, the second player must choose a movie in which the actor appeared.\n\n3. The next player can choose either an actor from the current movie or a movie featuring the current actor.\n\n4. Play continues in this fashion until a player answers incorrectly. An incorrect answer results in a strike. When a player reaches the strike limit, they are eliminated from the game. The last remaining player is the winner.\n\n"
    }
    
    override func viewDidLayoutSubviews() {
        instructionsTextView.setContentOffset(CGPoint.zero, animated: false)
    }
}
