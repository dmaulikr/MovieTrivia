//
//  GameplayViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 11/11/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import UIKit

class GameplayViewController: UIViewController {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    var movies = [Movie]()
    var actors = [Person]()
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var movieButton: RadioButton!
    @IBOutlet weak var actorButton: RadioButton!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Player 1"
        self.tableViewHeight.constant = 0
        movieButton.isSelected = true
        actorButton.isSelected = false
    }
    
    //----------------------------------
    // MARK: View Methods
    //----------------------------------
    
    @IBAction func radioButtonTapped(sender: RadioButton) {
        
        if sender == movieButton {
            movieButton.isSelected = true
            actorButton.isSelected = false
        } else {
            actorButton.isSelected = true
            movieButton.isSelected = false
        }
        
        guard searchBar.text != "" else {
            return
        }
        
        updateTable(searchText: searchBar.text!)
    }
    
    func updateTable(searchText: String) {
        
        if movieButton.isSelected {
            
            MDBClient().searchDatabase(queryInput: searchText, queryType: MDBClient.movie) { (movies, actors, error) in
                
                guard error == nil else {
                    // TODO: Handle error.
                    return
                }
                
                guard let movies = movies else {
                    // TODO: Handle error.
                    return
                }
                
                self.movies = [Movie]()
                
                for movie in movies {
                    self.movies.append(movie)
                }
                
                self.tableView.reloadData()
            }
            
        } else {
            
            MDBClient().searchDatabase(queryInput: searchText, queryType: MDBClient.person) { (movies, actors, error) in
                
                guard error == nil else {
                    // TODO: Handle error.
                    return
                }
                
                guard let actors = actors else {
                    // TODO: Handle error.
                    return
                }
                
                self.actors = [Person]()
                
                for actor in actors {
                    self.actors.append(actor)
                }
                
                self.tableView.reloadData()
            }
        }
    }
}

extension GameplayViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            movies = [Movie]()
            actors = [Person]()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.tableViewHeight.constant = 0
                self.view.layoutIfNeeded()
            })
            
            tableView.reloadData()
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tableViewHeight.constant = 200.0
            self.view.layoutIfNeeded()
        })
        
        updateTable(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension GameplayViewController: UITableViewDelegate, UITableViewDataSource {

    //----------------------------------
    // MARK: Table View Delegate
    //----------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "searchCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as UITableViewCell!
        
        cell?.textLabel!.font = UIFont(name: "Futura", size: 17)
        
        if movieButton.isSelected {
            
            let movie = movies[indexPath.row]
            
            if let releaseYear = movie.releaseYear {
                cell?.textLabel!.text = "\(movie.title) (\(releaseYear))"
            } else {
                cell?.textLabel!.text = movie.title
            }
            
        } else {
            
            let actor = actors[indexPath.row]
            cell?.textLabel!.text = actor.name
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if movieButton.isSelected {
            return movies.count
        } else {
            return actors.count
        }
        
    }
}

