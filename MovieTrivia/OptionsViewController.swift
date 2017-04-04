//
//  OptionsViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 1/2/17.
//  Copyright © 2017 Theodore Rothrock. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    var currentPlayer: Player!
    var game: Game!
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var instructionsButton: CustomButton!
    @IBOutlet weak var quitButton: CustomButton!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = currentPlayer.color
        
        instructionsButton.setTitleColor(currentPlayer.color, for: .highlighted)
        quitButton.setTitleColor(currentPlayer.color, for: .highlighted)
    }
    
    //----------------------------------
    // MARK: Page Methods
    //----------------------------------
    
    @IBAction func quit() {
        
        let alert = UIAlertController(title: "Are you sure?", message: "Your game will not be saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            _ = self.navigationController?.popToRootViewController(animated: true)
            CoreDataStackManager.sharedInstance.deleteGame() { error in
                // TODO: Handle error.
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //----------------------------------
    // MARK: Navigation
    //----------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "optionsToInstructions" {
            
            let instructionsVC = segue.destination as! InstructionsViewController
            instructionsVC.currentPlayer = self.currentPlayer
            instructionsVC.game = self.game
        }
    }
}
