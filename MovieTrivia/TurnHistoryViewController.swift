//
//  TurnHistoryViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 1/1/17.
//  Copyright © 2017 Theodore Rothrock. All rights reserved.
//

import UIKit

class TurnHistoryViewController: UITableViewController{
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    var game: Game? = nil
    
    //----------------------------------
    // MARK: Table View Delegate
    //----------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Turn History"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game!.history!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "turnCell", for: indexPath) as UITableViewCell
        
        let turn = game!.history![indexPath.row]
        
        cell.textLabel!.font = UIFont(name: "Futura", size: 17)
        cell.textLabel!.textColor = UIColor.white
        
        print(turn)
        
        if turn.movie == nil {
            cell.textLabel!.text = "\(turn.actor!.name)"
        } else {
            cell.textLabel!.text = "\(turn.movie!.title) (\(turn.movie!.releaseYear!))"
        }
        
        cell.backgroundColor = turn.player.color!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    //----------------------------------
    // MARK: Navigation
    //----------------------------------
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

}
