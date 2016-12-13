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
    var numberOfPlayers = 2
    var managedObjectContext: NSManagedObjectContext {return CoreDataStackManager.sharedInstance().managedObjectContext}
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial picker value.
        
        pickerView.selectRow(1, inComponent: 0, animated: false)
    }
    
    //----------------------------------
    // MARK: View Methods
    //----------------------------------
    
    @IBAction func setPlayers() {
        
        for index in 1...numberOfPlayers {
            
            let player = Player(name: "Player\(index)", context: managedObjectContext)
            players.append(player)
        }
        
        game = Game(players: players, context: managedObjectContext)
        
        for player in (game?.players)! {
            print(player.name)
        }
    }
}

extension PlayerPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //----------------------------------
    // MARK: Picker View Delegate
    //----------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 8
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        var title = NSAttributedString()
        title = NSAttributedString(string: String(row + 1), attributes: [NSFontAttributeName: UIFont(name: "Futura", size: 17.0)!, NSForegroundColorAttributeName: UIColor.white])
        pickerLabel.attributedText = title
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        numberOfPlayers = row + 1
    }
}

