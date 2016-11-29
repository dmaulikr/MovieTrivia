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
    var actors = [Actor]()
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var movieButton: RadioButton!
    @IBOutlet weak var actorButton: RadioButton!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var actorImage: UIImageView!
    @IBOutlet weak var actorLabel: UILabel!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // TODO: Update view controller title to reflect current player.
        
        self.title = "Player 1"
        
        // Hide search suggestion table view.
        
        self.tableViewHeight.constant = 0
        
        // Set initial radio button values.
        
        movieButton.isSelected = true
        actorButton.isSelected = false
        
        // Style 'Now playing' label and movie/actor images.
        
        imageTitleLabel.layer.cornerRadius = 10.0
        imageTitleLabel.layer.masksToBounds = true
        
        moviePosterImage.layer.borderWidth = 2
        moviePosterImage.layer.borderColor = UIColor.white.cgColor
        moviePosterImage.layer.cornerRadius = 10.0
        moviePosterImage.layer.masksToBounds = true
    
        actorImage.layer.borderWidth = 2
        actorImage.layer.borderColor = UIColor.white.cgColor
        actorImage.layer.cornerRadius = 10.0
        actorImage.layer.masksToBounds = true
        
        // Set searchBar keyboard return key property.
        
        searchBar.returnKeyType = .go
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
    
    @IBAction func backgroundTapped() {
        
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tableViewHeight.constant = 0
            self.blurView.alpha = 0.0
            self.view.layoutIfNeeded()
        })
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
                
                self.actors = [Actor]()
                
                for actor in actors {
                    self.actors.append(actor)
                }
                
                self.tableView.reloadData()
            }
        }
    }
}

extension GameplayViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blurView.alpha = 0.8
        })
        
        if searchBar.text != "" {
            UIView.animate(withDuration: 0.5, animations: {
                self.tableViewHeight.constant = 200.0
                self.view.layoutIfNeeded()
            })
            updateTable(searchText: searchBar.text!)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            movies = [Movie]()
            actors = [Actor]()
            
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
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tableViewHeight.constant = 0.0
            self.blurView.alpha = 0.0
            self.view.layoutIfNeeded()
        })
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

