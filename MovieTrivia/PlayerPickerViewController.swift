//
//  PlayerPickerViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 12/6/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import UIKit
import CoreData

class PlayerPickerViewController: UIViewController {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    var game: Game? = nil
    var players = [Player]()
    var managedObjectContext: NSManagedObjectContext {return CoreDataStackManager.sharedInstance().managedObjectContext}
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var playerCountContainer: UIView!
    @IBOutlet weak var stepper: UIStepper!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Players"
        
        playerCountContainer.layer.cornerRadius = playerCountContainer.frame.width / 2
        playerCountContainer.layer.masksToBounds = true
        
        stepper.minimumValue = 2.0
        stepper.maximumValue = 8.0
    }
    
    //----------------------------------
    // MARK: Page Methods
    //----------------------------------
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        
        playerCountLabel.text = String(Int(stepper.value))
    }
    
    //----------------------------------
    // MARK: Navigation
    //----------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        for index in 1...Int(stepper.value) {
            
            let player = Player(name: "Player \(index)", context: managedObjectContext)
            players.append(player)
        }
        
        game = Game(players: players, context: managedObjectContext)
        
        let colorPickerViewController = segue.destination as! ColorPickerViewController
        colorPickerViewController.game = game
    }
}


