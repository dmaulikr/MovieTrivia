//
//  GameplayViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 11/11/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import UIKit
import CoreData

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
    var managedObjectContext: NSManagedObjectContext {return CoreDataStackManager.sharedInstance().managedObjectContext}
    
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
    
    struct setupObjects {
        
        let whatAboutBob = Movie(
            dictionary: [
                "title": "What About Bob?" as AnyObject,
                "release_date": "1991-05-17" as AnyObject,
                "poster_path": "/fopJnM6MCZilYM6nRpglWdFndt1.jpg" as AnyObject,
                "id": 10276 as AnyObject
            ],
            context: CoreDataStackManager.sharedInstance().managedObjectContext
        )
        
        let billMurray = Actor(
            dictionary: [
                "name": "Bill Murray" as AnyObject,
                "profile_path": "/lBXifSLzs1DuspaWkACjSfjlwbd.jpg" as AnyObject,
                "id": 1532 as AnyObject
            ],
            context: CoreDataStackManager.sharedInstance().managedObjectContext)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // DELETE BELOW. Temporary setup.
        
        player1 = Player(name: "Player 1", context: managedObjectContext)
        player2 = Player(name: "Player 2", context: managedObjectContext)
        game = Game(players: [player1!, player2!], context: managedObjectContext)
        
        currentPlayer = player1
        currentMovie = setupObjects().whatAboutBob
        
        MDBClient().getMovieImage(movie: currentMovie!) { (image, error) in
            
            guard error == nil else {
                // TODO: Handle error.
                return
            }
            
            self.moviePosterImage.image = image
            self.movieLabel.text = self.currentMovie?.title
        }
        
        MDBClient().getCast(movie: currentMovie!) { (cast, error) in
            
            self.currentMovie!.cast = cast!
        }
        
        // DELETE ABOVE
        
        self.title = currentPlayer?.name
        
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
        
        searchBar.returnKeyType = .done
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
    
    //----------------------------------
    // MARK: Helper Functions
    //----------------------------------
    
    func dismissTable() {
        
        self.searchBar.text = ""
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tableViewHeight.constant = 0.0
            self.blurView.alpha = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    func verifyAnswer(movie: Movie, actor: Actor, completionHandler: @escaping (_ correct: Bool?, _ error: Error?) -> Void) {
        
        switch movieButton.isSelected {
            
        case true:
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
                
                for castMember in movie.cast! {
                    if castMember.name == actor.name {
                        completionHandler(true, nil)
                        return
                    }
                }
                
                completionHandler(false, nil)
            }
            break
            
        case false:
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
                
                for film in actor.filmography! {
                    if film.title == movie.title {
                        completionHandler(true, nil)
                        return
                    }
                }
                
                completionHandler(false, nil)
            }
            break
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
        
        switch movieButton.isSelected {
            
        case true:
            currentMovie = movies[indexPath.row]
            
            // Set movie image and label.
            
            MDBClient().getMovieImage(movie: currentMovie!) { (image, error) in
                
                guard error == nil else {
                    // TODO: Handle error.
                    return
                }
                
                self.moviePosterImage.image = image
                self.movieLabel.text = self.currentMovie?.title
            }
            break
            
        case false:
            currentActor = actors[indexPath.row]
            
            // Set actor image and label.
            
            MDBClient().getActorImage(actor: currentActor!) { (image, error) in
                
                guard error == nil else {
                    // TODO: Handle error.
                    return
                }
                
                self.actorImage.image = image
                self.actorLabel.text = self.currentActor?.name
            }
            break
        }
        
        verifyAnswer(movie: currentMovie!, actor: currentActor!) { (correct, error) in
            
            print("Verifying that \(self.currentActor!.name) appeared in '\(self.currentMovie!.title)': \(correct!)")
            
            guard error == nil else {
                // TODO: Handle error.
                return
            }
            
            guard let correct = correct else {
                // TODO: Handle error.
                return
            }
            
            let _ = Turn(player: self.currentPlayer!, game: self.game!, success: correct, round: 1, movie: self.currentMovie!, actor: self.currentActor!, context: self.managedObjectContext)
            
            CoreDataStackManager.sharedInstance().saveContext() { error in
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
