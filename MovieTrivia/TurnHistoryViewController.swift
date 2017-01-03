//
//  TurnHistoryViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 1/1/17.
//  Copyright © 2017 Theodore Rothrock. All rights reserved.
//

import UIKit

class TurnHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var game: Game? = nil
    var selectedTurn: Turn? = nil
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var explanationLabel: UILabel!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Turn History"

        if game!.history!.count == 0 {
            explanationLabel.isHidden = false
        } else {
            explanationLabel.isHidden = true
        }
        
        table.indicatorStyle = .white
        table.tableFooterView = UIView()
        
        // Scroll to bottom of table.
        
        if table.numberOfRows(inSection: 0) > 0 {
            let indexPath = IndexPath(row: table.numberOfRows(inSection: 0) - 1, section: 0)
            table.scrollToRow(at: indexPath, at: .middle, animated: false)
        }
        
    }
    
    //----------------------------------
    // MARK: Table View Delegate
    //----------------------------------

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game!.history!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "turnCell", for: indexPath) as UITableViewCell
        
        let turn = game!.history![indexPath.row]
        
        cell.textLabel!.font = UIFont(name: "Futura", size: 17)
        cell.textLabel!.textColor = UIColor.white
        
        if turn.movie == nil {
            cell.textLabel!.text = "\(turn.actor!.name)"
        } else {
            cell.textLabel!.text = "\(turn.movie!.title) (\(turn.movie!.releaseYear!))"
        }
        
        cell.backgroundColor = turn.player.color!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedTurn = game!.history![indexPath.row]
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    //----------------------------------
    // MARK: Navigation
    //----------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailVC = segue.destination as! TurnDetailViewController
        detailVC.turn = selectedTurn
    }
}
