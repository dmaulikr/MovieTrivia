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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let lastTurn = game?.history?.last else {
            return 1
        }
        
        return lastTurn.round
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Round \(section + 1)"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 17)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Filter out turns not associated with the current round/section.
        
        let turnsForRound = self.game!.history!.filter() {$0.round == section + 1}
        return turnsForRound.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "turnCell", for: indexPath) as UITableViewCell
        
        let turnsForSection = self.game!.history!.filter() {$0.round == indexPath.section + 1}
        
        let turn = turnsForSection[indexPath.row]
        
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
