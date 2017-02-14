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
    
    var managedObjectContext: NSManagedObjectContext {return CoreDataStackManager.sharedInstance.managedObjectContext}
    
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
        
        playerCountContainer.layer.cornerRadius = playerCountContainer.frame.width / 2
        playerCountContainer.layer.masksToBounds = true
        playerCountContainer.layer.borderColor = UIColor.white.cgColor
        playerCountContainer.layer.borderWidth = 2.0
        
        stepper.minimumValue = 2.0
        stepper.maximumValue = 8.0
    }
    
    override func viewWillLayoutSubviews() {
        let radialGradient = RadialGradientLayer(center: self.view.center, radius: self.view.frame.height / 2, colors: [UIColor.red.cgColor, UIColor.black.cgColor])
        radialGradient.frame = self.view.bounds
        self.view.layer.insertSublayer(radialGradient, at: 0)
        radialGradient.setNeedsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
    }
    
    //----------------------------------
    // MARK: Page Methods
    //----------------------------------
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        
        playerCountLabel.text = String(Int(stepper.value))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var players = [Player]()
        
        for index in 1...Int(stepper.value) {
            
            let player = Player(name: "Player \(index)", context: managedObjectContext)
            players.append(player)
        }
        
        let game = Game(context: managedObjectContext)
        
        for player in players {
            player.game = game
        }
        
        let colorPickerViewController = segue.destination as! ColorPickerViewController
        colorPickerViewController.game = game
    }
}


