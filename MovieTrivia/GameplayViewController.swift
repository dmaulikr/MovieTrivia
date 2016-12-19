//
//  GameplayViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 11/11/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import UIKit
import CoreData
import PKHUD

class GameplayViewController: UIViewController {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    var movies = [Movie]()
    var actors = [Actor]()
    var currentMovie: Movie? = nil
    var currentActor: Actor? = nil
    var player1: Player? = nil
    var player2: Player? = nil
    var currentPlayer: Player? = nil
    var currentRound: Int? = nil
    var game: Game? = nil
    var isInitialPick = true
    var managedObjectContext: NSManagedObjectContext {return CoreDataStackManager.sharedInstance.managedObjectContext}
    
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
        
        // Set initial gampeplay values.
        
        currentPlayer = game?.players?[0]
        self.title = currentPlayer?.name
        
        // Set up UI.
        
        navigationItem.hidesBackButton = true
        
        self.tableViewHeight.constant = 0
        
        movieButton.isSelected = true
        
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
        
        searchBar.returnKeyType = .done
    }
    
    //----------------------------------
    // MARK: Page Methods
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
        
        var queryType: String
        
        switch movieButton.isSelected {
            
        case true:
            queryType = MDBClient.movie
            break
            
        case false:
            queryType = MDBClient.person
            break
        }
        
        MDBClient().searchDatabase(queryInput: searchText, queryType: queryType) { (movies, actors, error) in
            
            guard error == nil else {
                // TODO: Handle error.
                return
            }
            
            switch self.movieButton.isSelected {
                
            case true:
                guard let movies = movies else {
                    // TODO: Handle error.
                    return
                }
                self.movies = [Movie]()
                for movie in movies {
                    self.movies.append(movie)
                }
                break
                
            case false:
                guard let actors = actors else {
                    // TODO: Handle error.
                    return
                }
                self.actors = [Actor]()
                for actor in actors {
                    self.actors.append(actor)
                }
                break
            }
            
            self.tableView.reloadData()
        }
    }
    
    func dismissTable() {
        
        self.searchBar.text = ""
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tableViewHeight.constant = 0.0
            self.blurView.alpha = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    func verifyAnswer(movie: Movie?, actor: Actor?, completionHandler: @escaping (_ correct: Bool?, _ error: Error?) -> Void) {
        
        switch movieButton.isSelected {
            
        case true:
            
            guard let movie = movie else {return}
            
            MDBClient().getCast(movie: movie) { (cast, error) in
                
                guard error == nil else {
                    // TODO: Handle error.
                    return
                }
                
                guard let cast = cast else {
                    // TODO: Handle error.
                    return
                }
                
                movie.cast = cast
                
                guard !self.isInitialPick else {
                    
                    self.isInitialPick = false
                    completionHandler(true, nil)
                    return
                }
                
                guard let actor = actor else {return}
                
                for castMember in movie.cast! {
                    if castMember.name == actor.name {
                        completionHandler(true, nil)
                        return
                    }
                }
                
                completionHandler(false, nil)
            }
            return
            
        case false:
            
            guard let actor = actor else {return}
            
            MDBClient().getFilmography(actor: actor) { (filmography, error) in
                
                guard error == nil else {
                    // TODO: Handle error.
                    return
                }
                
                guard let filmography = filmography else {
                    // TODO: Handle error.
                    return
                }
                
                actor.filmography = filmography
                
                guard !self.isInitialPick else {
                    
                    self.isInitialPick = false
                    completionHandler(true, nil)
                    return
                }
                
                guard let movie = movie else {return}
                
                for film in actor.filmography! {
                    if film.title == movie.title {
                        completionHandler(true, nil)
                        return
                    }
                }
                
                completionHandler(false, nil)
            }
            return
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "searchCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as UITableViewCell!
        
        cell?.textLabel!.font = UIFont(name: "Futura", size: 17)
        
        switch movieButton.isSelected {
            
        case true:
            let movie = movies[indexPath.row]
            if let releaseYear = movie.releaseYear {
                cell?.textLabel!.text = "\(movie.title) (\(releaseYear))"
            } else {
                cell?.textLabel!.text = movie.title
            }
            break
            
        case false:
            let actor = actors[indexPath.row]
            cell?.textLabel!.text = actor.name
            break
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch movieButton.isSelected {
            
        case true:
            return movies.count
            
        case false:
            return actors.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isInitialPick && ((movieButton.isSelected && currentActor == nil) || (actorButton.isSelected && currentMovie == nil)) {
            
            // Second player is attempting to pick a value of the same type as the initial value, e.g. movie + movie.
            
            let alertMessage = "You have to pick " + (movieButton.isSelected ? "an actor.": "a movie.")
            let alert = UIAlertController(title: "Oops!", message: alertMessage, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okayAction)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        switch movieButton.isSelected {
            
        case true:
            
            currentMovie = movies[indexPath.row]
            
            // Set movie label and image.
            
            self.movieLabel.text = self.currentMovie?.title
            
            MDBClient().getMovieImage(movie: currentMovie!) { (image, error) in
                
                guard error == nil else {
                    // TODO: Handle error.
                    print("Error retrieving movie image.")
                    return
                }
                
                self.moviePosterImage.image = image
            }
            break
            
        case false:
            
            currentActor = actors[indexPath.row]
            
            // Set actor label and image.
            
            self.actorLabel.text = self.currentActor?.name
            
            MDBClient().getActorImage(actor: currentActor!) { (image, error) in
                
                guard error == nil else {
                    // TODO: Handle error.
                    print("Error retrieving actor image.")
                    return
                }
                
                self.actorImage.image = image
            }
            break
        }
        
        verifyAnswer(movie: currentMovie, actor: currentActor) { (correct, error) in
            
            guard error == nil else {
                // TODO: Handle error.
                return
            }
            
            guard let correct = correct else {
                // TODO: Handle error.
                return
            }
            
            if correct && self.currentMovie != nil && self.currentActor != nil {
                HUD.flash(.success, delay: 1.5)
            } else if !correct && self.currentMovie != nil && self.currentActor != nil {
                HUD.flash(.error, delay: 1.5)
            }
            
            // Save turn history.
            
            let _ = Turn(player: self.currentPlayer!, game: self.game!, success: correct, round: 1, movie: self.currentMovie, actor: self.currentActor, context: self.managedObjectContext)
            
            CoreDataStackManager.sharedInstance.saveContext() { error in
                guard error == nil else {
                    // TODO: Handle error.
                    return
                }
            }
        }
        
        // TODO: Clear cache of unused Movie and Actor objects from managedObjectContext.
        
        dismissTable()
    }
}
