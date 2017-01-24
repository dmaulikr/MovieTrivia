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
import SideMenu

class GameplayViewController: UIViewController {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    var movies = [Movie]()
    var actors = [Actor]()
    var activePlayers = [Player]()
    var currentMovie: Movie? = nil
    var currentActor: Actor? = nil
    var currentPlayer: Player? = nil
    var currentRound = 1
    var game: Game? = nil
    var isInitialPick = true
    var managedObjectContext: NSManagedObjectContext {return CoreDataStackManager.sharedInstance.managedObjectContext}
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var radioButtonContainer: UIView!
    @IBOutlet weak var movieButton: RadioButton!
    @IBOutlet weak var actorButton: RadioButton!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var actorImage: UIImageView!
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreCollectionView: UICollectionView!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set initial gampeplay values.
        
        activePlayers = game!.players!
        currentPlayer = game?.players?[0]
        self.title = currentPlayer?.name
        
        // Set up UI.
        
        updateUIForCurrentPlayer(clearPreviousAnswers: false)
        
        navigationItem.hidesBackButton = true
        
        self.tableViewHeight.constant = 0
        
        movieButton.isSelected = true
        actorButton.isSelected = false
        
        movieLabel.text = ""
        actorLabel.text = ""
        
        imageTitleLabel.layer.cornerRadius = 10.0
        imageTitleLabel.layer.masksToBounds = true
        
        scoreLabel.layer.cornerRadius = 10.0
        scoreLabel.layer.masksToBounds = true
        
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
    
    func updateUIForCurrentPlayer(clearPreviousAnswers: Bool) {
        
        guard let currentPlayer = currentPlayer else {return}
        guard let playerColor = currentPlayer.color else {return}
        
        self.title = currentPlayer.name
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = playerColor
            self.radioButtonContainer.backgroundColor = playerColor
            self.scoreCollectionView.backgroundColor = playerColor
        })
        
        UIView.transition(with: self.imageTitleLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {self.imageTitleLabel.textColor = playerColor}, completion: nil)
        UIView.transition(with: self.scoreLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {self.scoreLabel.textColor = playerColor}, completion: nil)
        
        if clearPreviousAnswers {
            
            self.currentActor = nil
            self.actorLabel.text = ""
            self.actorImage.image = nil
            
            self.currentMovie = nil
            self.movieLabel.text = nil
            self.moviePosterImage.image = nil
        }
    }
    
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
    
    func verifyAnswer(movie: Movie?, actor: Actor?, completionHandler: @escaping (_ correct: Bool?) -> Void) {
        
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
                    
                    completionHandler(true)
                    return
                }
                
                guard let actor = actor else {return}
                
                for castMember in movie.cast! {
                    if castMember.name == actor.name {
                        completionHandler(true)
                        return
                    }
                }
                
                completionHandler(false)
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
                    
                    completionHandler(true)
                    return
                }
                
                guard let movie = movie else {return}
                
                for film in actor.filmography! {
                    if film.title == movie.title {
                        completionHandler(true)
                        return
                    }
                }
                
                completionHandler(false)
            }
            return
        }
    }
    
    func clearCache() {
        
        var actorsToSave = [Actor]()
        var moviesToSave = [Movie]()
        
        for turn in game!.history! {
            if let actor = turn.actor {
                actorsToSave.append(actor)
                for movie in actor.filmography! {
                    moviesToSave.append(movie)
                }
            }
            if let movie = turn.movie {
                moviesToSave.append(movie)
                for actor in movie.cast! {
                    actorsToSave.append(actor)
                }
            }
        }
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        
        do {
            let list = try managedObjectContext.fetch(fetchRequest) as! [Movie]
            for movie in list {
                if !moviesToSave.contains(movie) {
                    managedObjectContext.delete(movie)
                }
            }
        } catch {
            let error = error as Error
            print("Encountered error: \(error.localizedDescription)")
        }
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Actor")
        
        do {
            let list = try managedObjectContext.fetch(fetchRequest) as! [Actor]
            for actor in list {
                if !actorsToSave.contains(actor) {
                    managedObjectContext.delete(actor)
                }
            }
        } catch {
            let error = error as NSError
            print("Encountered error: \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showHistory" {
            
            let navigationController = segue.destination as! UISideMenuNavigationController
            let historyVC = navigationController.topViewController as! TurnHistoryViewController
            historyVC.game = self.game
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as UITableViewCell
        
        cell.textLabel!.font = UIFont(name: "Futura", size: 17)
        
        switch movieButton.isSelected {
            
        case true:
            let movie = movies[indexPath.row]
            if let releaseYear = movie.releaseYear {
                cell.textLabel!.text = "\(movie.title) (\(releaseYear))"
            } else {
                cell.textLabel!.text = movie.title
            }
            break
            
        case false:
            let actor = actors[indexPath.row]
            cell.textLabel!.text = actor.name
            break
        }
        
        return cell
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
        
        self.dismissTable()
        
        // Show progress HUD.
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        setImageForTurn(indexOfSelectedRow: indexPath.row) { (success) in
            
            guard success else {
                // TODO: Handle error.
                return
            }
            
            self.verifyAnswer(movie: self.currentMovie, actor: self.currentActor) { (correct) in
                
                guard let correct = correct else {
                    // TODO: Handle error.
                    return
                }
                
                // Save turn and clear cache.
                
                self.saveTurn(correct: correct)
                self.clearCache()
                CoreDataStackManager.sharedInstance.saveContext() { error in
                    guard error == nil else {
                        // TODO: Handle error.
                        return
                    }
                }
                
                // Show success/error HUD.
                
                var clearPreviousAnswers = false
                
                if self.isInitialPick {
                    
                    self.isInitialPick = false
                    PKHUD.sharedHUD.hide(true)
                    self.updateCurrentPlayer()
                    self.updateUIForCurrentPlayer(clearPreviousAnswers: false)
                    return
                    
                } else if correct {
                    
                    // Correct answer.
                    
                    PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                    
                } else {
                    
                    // Incorrect answer.
                    
                    PKHUD.sharedHUD.contentView = PKHUDErrorView()
                    self.currentPlayer?.score += 1
                    self.scoreCollectionView.reloadData()
                    self.isInitialPick = true
                    clearPreviousAnswers = true
                }
                
                // Update UI for the next player.
                
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { (timerAction) in
                    
                    self.updateCurrentPlayer()
                    self.updateUIForCurrentPlayer(clearPreviousAnswers: clearPreviousAnswers)
                }
            }
        }
    }
    
    func updateCurrentPlayer() {
        
        let indexOfCurrentPlayer = self.activePlayers.index(of: self.currentPlayer!)!
        var playerEliminated = false
        
        if self.currentPlayer!.score == UserDefaults.standard.integer(forKey: "strikeMax") {
            self.activePlayers = self.activePlayers.filter() {$0 != self.currentPlayer!}
            playerEliminated = true
        }
        
        if playerEliminated {
            
            if indexOfCurrentPlayer == self.activePlayers.count {
                self.currentPlayer = self.activePlayers[0]
            } else {
                self.currentPlayer = self.activePlayers[indexOfCurrentPlayer]
            }
            
            let alert = UIAlertController(title: "\(self.currentPlayer!.name) has been eliminated.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            if indexOfCurrentPlayer < self.activePlayers.count - 1 {
                self.currentPlayer = self.activePlayers[indexOfCurrentPlayer + 1]
            } else {
                self.currentPlayer = self.activePlayers[0]
            }
        }
    }
    
    func setImageForTurn(indexOfSelectedRow: Int, completionHandler: @escaping (_ success: Bool) -> Void) {
        
        switch movieButton.isSelected {
            
        case true:
            
            currentMovie = movies[indexOfSelectedRow]
            
            // Set movie label and image.
            
            self.movieLabel.text = self.currentMovie?.title
            
            MDBClient().getMovieImage(movie: currentMovie!) { (image, error) in
                
                guard error == nil else {
                    // TODO: Handle error.
                    print("Error retrieving movie image.")
                    completionHandler(false)
                    return
                }
                
                self.moviePosterImage.image = image
                completionHandler(true)
            }
            break
            
        case false:
            
            currentActor = actors[indexOfSelectedRow]
            
            // Set actor label and image.
            
            self.actorLabel.text = self.currentActor?.name
            
            MDBClient().getActorImage(actor: currentActor!) { (image, error) in
                
                guard error == nil else {
                    // TODO: Handle error.
                    print("Error retrieving actor image.")
                    return
                }
                
                self.actorImage.image = image
                completionHandler(true)
            }
            break
        }
    }
    
    func saveTurn(correct: Bool) {
        
        if self.movieButton.isSelected {
            
            let _ = Turn(player: self.currentPlayer!, game: self.game!, success: correct, round: self.currentRound, movie: self.currentMovie, actor: nil, context: self.managedObjectContext)
            
        } else {
            
            let _ = Turn(player: self.currentPlayer!, game: self.game!, success: correct, round: self.currentRound, movie: nil, actor: self.currentActor, context: self.managedObjectContext)
        }
    }
}

extension GameplayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game!.players!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scoreCell", for: indexPath) as! ScoreCell
        
        cell.styleCell(color: game!.players![indexPath.row].color!)
        cell.scoreLabel.text = String(game!.players![indexPath.row].score)
        
        return cell
    }
}
