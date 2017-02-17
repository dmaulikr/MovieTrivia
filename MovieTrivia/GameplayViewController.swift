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
    var currentPlayer: Player!
    var currentRound = 1
    var game: Game!
    var isInitialPick = true
    var showingInstructions = false
    var instructionsScenario = "Started"
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
    @IBOutlet weak var topArrow: UIImageView!
    @IBOutlet weak var topInstructions: UILabel!
    @IBOutlet weak var bottomInstructions: UILabel!
    @IBOutlet weak var bottomArrow: UIImageView!
    @IBOutlet weak var scoreCollectionView: UICollectionView!
    @IBOutlet weak var scoreCollectionBackground: UIView!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set initial gampeplay values.
        
        activePlayers = game.players
        currentPlayer = game.players[0]
        self.title = currentPlayer.name
        
        // Set up UI.
        
        self.title = currentPlayer.name
        
        self.view.backgroundColor = currentPlayer.color
        self.radioButtonContainer.backgroundColor = currentPlayer.color
        self.scoreCollectionView.backgroundColor = currentPlayer.color
        self.scoreCollectionBackground.backgroundColor = currentPlayer.color
        self.imageTitleLabel.textColor = currentPlayer.color
        self.scoreLabel.textColor = currentPlayer.color
        
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
        
        if let arrowImage = #imageLiteral(resourceName: "arrow").cgImage {
            bottomArrow.image = UIImage(cgImage: arrowImage, scale: 1.0, orientation: .downMirrored)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "showInstructions") {
            
            // User is playing for the first time. Disable nav bar items and display instructional text.
            
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            showingInstructions = true
            topInstructions.text = "Player 1, use the search bar at the top of the screen to choose a movie or an actor to start the round."
            UIView.animate(withDuration: 0.5, animations: {
                self.topInstructions.alpha = 1.0
                self.topArrow.alpha = 1.0
                self.blurView.alpha = 0.85
            })
        }
    }
    
    //----------------------------------
    // MARK: UI Methods
    //----------------------------------
    
    func updateUIForCurrentPlayer(clearPreviousAnswers: Bool) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = self.currentPlayer.color
            self.radioButtonContainer.backgroundColor = self.currentPlayer.color
            self.scoreCollectionView.backgroundColor = self.currentPlayer.color
            self.scoreCollectionBackground.backgroundColor = self.currentPlayer.color
        })
        
        UIView.transition(with: self.imageTitleLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {self.imageTitleLabel.textColor = self.currentPlayer.color}, completion: nil)
        UIView.transition(with: self.scoreLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {self.scoreLabel.textColor = self.currentPlayer.color}, completion: nil)

        self.title = self.currentPlayer.name
        
        if clearPreviousAnswers {
            
            self.currentActor = nil
            self.currentMovie = nil
            
            UIView.transition(with: self.actorImage, duration: 0.5, options: .transitionCrossDissolve, animations: {self.actorImage.image = #imageLiteral(resourceName: "person")}, completion: nil)
            UIView.transition(with: self.actorLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {self.actorLabel.text = ""}, completion: nil)
            UIView.transition(with: self.moviePosterImage, duration: 0.5, options: .transitionCrossDissolve, animations: {self.moviePosterImage.image = #imageLiteral(resourceName: "reel")}, completion: nil)
            UIView.transition(with: self.movieLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {self.movieLabel.text = ""}, completion: nil)
            UIView.transition(with: self.imageTitleLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {self.imageTitleLabel.text = "Round \(self.currentRound)"}, completion: nil)
        }
        
        if UserDefaults.standard.bool(forKey: "showInstructions") {
            
            switch instructionsScenario {
                
            case "Started":
                if let movie = currentMovie {
                    topInstructions.text = "\(currentPlayer.name), choose an actor from \"\(movie.title)\"."
                } else if let actor = currentActor {
                    topInstructions.text = "\(currentPlayer.name), choose a movie featuring \(actor.name)."
                } else {
                    // TODO: Handle error.
                }
            
                instructionsScenario = "ThirdSelection"
                break
                
            case "ThirdSelectionCorrectAnswer":
                guard let movie = currentMovie else {break}
                guard let actor = currentActor else {break}
                topInstructions.text = "Nice work! \(currentPlayer.name), you can now choose another actor from \"\(movie.title)\" or another movie featuring \(actor.name)."
                instructionsScenario = "StrikeExplanation"
                break
                
            case "ThirdSelectionIncorrectAnswer":
                topInstructions.text = "Oh no! That answer was incorrect. \(currentPlayer.name), choose a movie or an actor to start the next round."
                instructionsScenario = "StrikeExplanation"
                break
                
            case "StrikeExplanation":
                bottomInstructions.text = "That's it! Each incorrect answer earns you a strike. Three strikes and you're out. Good luck!"
                self.view.bringSubview(toFront: scoreCollectionBackground)
                self.view.bringSubview(toFront: scoreLabel)
                self.view.bringSubview(toFront: scoreCollectionView)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.blurView.alpha = 0.85
                        self.bottomInstructions.alpha = 1.0
                        self.bottomArrow.alpha = 1.0
                    })
                }
                
                // Enable nav bar items and update user defaults.
                
                self.navigationItem.leftBarButtonItem?.isEnabled = true
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                showingInstructions = false
                UserDefaults.standard.set(false, forKey: "showInstructions")
                return
                
            default:
                break
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.blurView.alpha = 0.85
                    self.topInstructions.alpha = 1.0
                    self.topArrow.alpha = 1.0
                })
            }
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
        
        guard let searchText = searchBar.text else {
            return
        }
        
        if searchText != "" {
            updateTable(searchText: searchText)
        }
    }
    
    @IBAction func backgroundTapped() {
        
        self.view.endEditing(true)
        
        if !showingInstructions {
            UIView.animate(withDuration: 0.5, animations: {
                self.tableViewHeight.constant = 0
                self.blurView.alpha = 0.0
                self.bottomInstructions.alpha = 0.0
                self.bottomArrow.alpha = 0.0
                self.view.sendSubview(toBack: self.scoreLabel)
                self.view.sendSubview(toBack: self.scoreCollectionView)
                self.view.sendSubview(toBack: self.scoreCollectionBackground)
                self.view.layoutIfNeeded()
            })
        }
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
        
        MDBClient().searchDatabase(queryInput: searchText, queryType: queryType) { (movies, actors, errorMessage) in
            
            if let errorMessage = errorMessage {
                self.displayAlert(type: errorMessage)
                return
            }
            
            switch self.movieButton.isSelected {
                
            case true:
                
                guard let movies = movies else {
                    return
                }
                
                self.movies = [Movie]()
                
                for movie in movies {
                    self.movies.append(movie)
                }
                
                break
                
            case false:
                
                guard let actors = actors else {
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
    
    func displayAlert(type: String) {
        
        var alertTitle = String()
        var alertMessage = String()
        
        switch type {
            
        case "Query failed.":
            alertTitle = "Unable to connect"
            alertMessage = "You must be connected to the internet to play. Please check your network settings and try again."
            break
            
        case "Unable to parse response.":
            alertTitle = "Uh-oh"
            alertMessage = "We were unable to process your selection. Please try again or make a different selection."
            break
            
        case "Response did not contain expected key.":
            alertTitle = "Uh-oh"
            alertMessage = "We were unable to process your selection. Please try again or make a different selection."
            break
            
        case "Repeat selection":
            alertTitle = "Not so fast"
            alertMessage = "Your selection has already been used this round. Pick a different movie or actor."
            
        case "Use dropdown menu":
            alertTitle = "Tap your selection"
            alertMessage = "Please use the dropdown menu to make your selection. If the movie or actor you're searching for doesn't appear in the list, check your spelling or try a different selection."
            
        default:
            break
        }
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setImageForTurn(indexOfSelectedRow: Int, completionHandler: @escaping () -> Void) {
        
        switch movieButton.isSelected {
            
        case true:
            
            currentMovie = movies[indexOfSelectedRow]
            guard let movie = currentMovie else {return}
            
            // Set movie label and image.
            
            MDBClient().getMovieImage(movie: movie, size: ImageSize.large) { (image, errorMessage) in
                
                UIView.transition(with: self.movieLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {self.movieLabel.text = self.currentMovie?.title}, completion: nil)
                
                if errorMessage != nil {
                    UIView.transition(with: self.moviePosterImage, duration: 0.5, options: .transitionCrossDissolve, animations: {self.moviePosterImage.image = #imageLiteral(resourceName: "reel")}, completion: nil)
                    completionHandler()
                    return
                }
                
                UIView.transition(with: self.moviePosterImage, duration: 0.5, options: .transitionCrossDissolve, animations: {self.moviePosterImage.image = image}, completion: nil)
                completionHandler()
            }
            
        case false:
            
            currentActor = actors[indexOfSelectedRow]
            guard let actor = currentActor else {return}
            
            // Set actor label and image.
            
            MDBClient().getActorImage(actor: actor, size: ImageSize.large) { (image, errorMessage) in
                
                UIView.transition(with: self.actorLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {self.actorLabel.text = self.currentActor?.name}, completion: nil)
                
                if errorMessage != nil {
                    UIView.transition(with: self.actorImage, duration: 0.5, options: .transitionCrossDissolve, animations: {self.actorImage.image = #imageLiteral(resourceName: "person")}, completion: nil)
                    completionHandler()
                    return
                }
                
                UIView.transition(with: self.actorImage, duration: 0.5, options: .transitionCrossDissolve, animations: {self.actorImage.image = image}, completion: nil)
                completionHandler()
            }
        }
    }
    
    //----------------------------------
    // MARK: Helper Methods
    //----------------------------------
    
    func verifyAnswer(movie: Movie?, actor: Actor?, completionHandler: @escaping (_ correct: Bool?) -> Void) {
        
        switch movieButton.isSelected {
            
        case true:
            
            guard let movie = movie else {
                completionHandler(nil)
                return
            }
            
            MDBClient().getCast(movie: movie) { (cast, errorMessage) in
                
                if let errorMessage = errorMessage {
                    self.displayAlert(type: errorMessage)
                    completionHandler(nil)
                    return
                }
                
                guard let cast = cast else {
                    completionHandler(nil)
                    return
                }
                
                movie.cast = cast
                
                guard !self.isInitialPick else {
                    completionHandler(true)
                    return
                }
                
                guard let actor = actor else {
                    completionHandler(nil)
                    return
                }
                
                for castMember in cast {
                    if castMember.name == actor.name {
                        completionHandler(true)
                        return
                    }
                }
                
                completionHandler(false)
            }
            
        case false:
            
            guard let actor = actor else {
                completionHandler(nil)
                return
            }
            
            MDBClient().getFilmography(actor: actor) { (filmography, errorMessage) in
                
                if let errorMessage = errorMessage {
                    self.displayAlert(type: errorMessage)
                    completionHandler(nil)
                    return
                }
                
                guard let filmography = filmography else {
                    completionHandler(nil)
                    return
                }
                
                actor.filmography = filmography
                
                guard !self.isInitialPick else {
                    
                    completionHandler(true)
                    return
                }
                
                guard let movie = movie else {
                    completionHandler(nil)
                    return
                }
                
                for film in filmography {
                    if film.title == movie.title {
                        completionHandler(true)
                        return
                    }
                }
                
                completionHandler(false)
            }
        }
    }
    
    func clearCache() {
        
        var actorsToSave = [Actor]()
        var moviesToSave = [Movie]()
        
        for turn in game.history {
            
            if let actor = turn.actor {
                actorsToSave.append(actor)
                if let filmography = actor.filmography {
                    for movie in filmography {
                        moviesToSave.append(movie)
                    }
                }
            }
            
            if let movie = turn.movie {
                moviesToSave.append(movie)
                if let cast = movie.cast {
                    for actor in cast {
                        actorsToSave.append(actor)
                    }
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
    
    func updateCurrentPlayer() {
        
        guard let indexOfCurrentPlayer = self.activePlayers.index(of: self.currentPlayer) else {return}
        
        if self.currentPlayer.score == 3 {
            
            self.activePlayers = self.activePlayers.filter() {$0 != self.currentPlayer}

            if self.activePlayers.count == 1 {
                
                // The game is over.
                
                let alert = UIAlertController(title: "The End", message: "\(self.activePlayers[0].name) wins!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    let _ = self.navigationController?.popToRootViewController(animated: true)
                    CoreDataStackManager.sharedInstance.deleteGame() { error in
                        // TODO: Handle error.
                    }
                })
                
                self.present(alert, animated: true, completion: nil)
                return
                
            } else {
                
                // A player has been eliminated.
                
                let alert = UIAlertController(title: "Take five", message: "\(self.currentPlayer.name) has been eliminated.", preferredStyle: .alert)
                
                if indexOfCurrentPlayer == self.activePlayers.count {
                    self.currentPlayer = self.activePlayers[0]
                } else {
                    self.currentPlayer = self.activePlayers[indexOfCurrentPlayer]
                }
                
                alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    
                    // Give alert dismissal animation a moment to complete before updating UI.
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.updateUIForCurrentPlayer(clearPreviousAnswers: true)
                    }
                })
                
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        
        // Play continues.
        
        if indexOfCurrentPlayer < self.activePlayers.count - 1 {
            self.currentPlayer = self.activePlayers[indexOfCurrentPlayer + 1]
        } else {
            self.currentPlayer = self.activePlayers[0]
        }
        
        if isInitialPick {
            updateUIForCurrentPlayer(clearPreviousAnswers: true)
        } else {
            updateUIForCurrentPlayer(clearPreviousAnswers: false)
        }
    }
    
    func saveTurn(correct: Bool) {
        
        if self.movieButton.isSelected {
            
            let _ = Turn(player: self.currentPlayer, game: self.game, success: correct, round: self.currentRound, movie: self.currentMovie, actor: nil, context: self.managedObjectContext)
            
        } else {
            
            let _ = Turn(player: self.currentPlayer, game: self.game, success: correct, round: self.currentRound, movie: nil, actor: self.currentActor, context: self.managedObjectContext)
        }
    }
    
    //----------------------------------
    // MARK: Navigation
    //----------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showHistory" {
            
            let navigationController = segue.destination as! UISideMenuNavigationController
            let historyVC = navigationController.topViewController as! TurnHistoryViewController
            historyVC.game = self.game
            
        } else if segue.identifier == "showOptions" {
            
            let optionsVC = segue.destination as! OptionsViewController
            optionsVC.currentPlayer = self.currentPlayer
        }
    }
}

//----------------------------------
// MARK: Search Bar Delegate
//----------------------------------

extension GameplayViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if topInstructions.alpha != 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.topInstructions.alpha = 0
                self.topArrow.alpha = 0
            })
        }
        
        if bottomInstructions.alpha != 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomInstructions.alpha = 0
                self.bottomArrow.alpha = 0
                self.view.sendSubview(toBack: self.scoreLabel)
                self.view.sendSubview(toBack: self.scoreCollectionView)
                self.view.sendSubview(toBack: self.scoreCollectionBackground)
            })
        }
        
        // Blur UI.
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blurView.alpha = 0.85
        })
        
        guard let text = searchBar.text else {return}
        
        if text != "" {
            
            // Open table if necessary.
            
            if self.tableViewHeight.constant == 0.0 {
                UIView.animate(withDuration: 0.5, animations: {
                    if UIScreen.main.bounds.height <= 568.0 {
                        self.tableViewHeight.constant = 150.0
                    } else {
                        self.tableViewHeight.constant = 200.0
                    }
                    self.view.layoutIfNeeded()
                })
            }
            
            updateTable(searchText: text)
            
            // Scroll to top of table if necessary.
            
            if self.tableView.numberOfRows(inSection: 0) > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            
            // Clear caches.
            
            movies = [Movie]()
            actors = [Actor]()
            
            // Close table.
            
            UIView.animate(withDuration: 0.5, animations: {
                self.tableViewHeight.constant = 0
                self.view.layoutIfNeeded()
            })
            
            tableView.reloadData()
            return
            
        } else {
            
            // Open table if necessary.
            
            if self.tableViewHeight.constant == 0.0 {
                UIView.animate(withDuration: 0.5, animations: {
                    if UIScreen.main.bounds.height <= 568.0 {
                        self.tableViewHeight.constant = 150.0
                    } else {
                        self.tableViewHeight.constant = 200.0
                    }
                    self.view.layoutIfNeeded()
                })
            }
            
            guard let text = searchBar.text else {return}
            
            updateTable(searchText: text)
            
            // Scroll to top of table if necessary.
            
            if self.tableView.numberOfRows(inSection: 0) > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }

        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        displayAlert(type: "Use dropdown menu")
    }
}

//----------------------------------
// MARK: Table View Delegate
//----------------------------------

extension GameplayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.font = UIFont(name: "Futura", size: 17)
        
        switch movieButton.isSelected {
            
        case true:
            let movie = movies[indexPath.row]
            if let releaseYear = movie.releaseYear {
                cell.textLabel?.text = "\(movie.title) (\(releaseYear))"
            } else {
                cell.textLabel?.text = movie.title
            }
            break
            
        case false:
            let actor = actors[indexPath.row]
            cell.textLabel?.text = actor.name
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
        
        self.dismissTable()
        
        // Verify that second player is not attempting to pick a value of the same type as the initial value, e.g. movie + movie.
        
        if !isInitialPick && ((movieButton.isSelected && currentActor == nil) || (actorButton.isSelected && currentMovie == nil)) {
            
            let alertMessage = "You have to pick " + (movieButton.isSelected ? "an actor.": "a movie.")
            let alert = UIAlertController(title: "Hold up", message: alertMessage, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okayAction)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Verify that the movie or actor selected has not already been used this round.
        
        let turnsForRound = game.history.filter() {$0.round == currentRound}
        var moviesForRound = [String]()
        var actorsForRound = [String]()
        
        for turn in turnsForRound {
            if let movie = turn.movie {
                moviesForRound.append(movie.title)
            }
            if let actor = turn.actor {
                actorsForRound.append(actor.name)
            }
        }
        
        if (movieButton.isSelected && moviesForRound.contains(movies[indexPath.row].title)) || (actorButton.isSelected && actorsForRound.contains(actors[indexPath.row].name)) {
            
            displayAlert(type: "Repeat selection")
            return
        }
        
        // Show progress HUD.
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        setImageForTurn(indexOfSelectedRow: indexPath.row) {
            
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
                
                if self.isInitialPick {
                    
                    // Initial pick.
                    
                    self.isInitialPick = false
                    PKHUD.sharedHUD.hide(true)
                    self.updateCurrentPlayer()
                    
                } else if correct {
                    
                    // Correct answer.
                    
                    PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                    if self.instructionsScenario == "ThirdSelection" {
                        self.instructionsScenario = "ThirdSelectionCorrectAnswer"
                    }
                    
                } else {
                    
                    // Incorrect answer.
                    
                    PKHUD.sharedHUD.contentView = PKHUDErrorView()
                    if self.instructionsScenario == "ThirdSelection" {
                        self.instructionsScenario = "ThirdSelectionIncorrectAnswer"
                    }
                    self.currentPlayer.score += 1
                    self.scoreCollectionView.reloadData()
                    self.isInitialPick = true
                    self.currentRound += 1
                }
                
                // Update UI for the next player.
                
                PKHUD.sharedHUD.hide(afterDelay: 1.5) { _ in
                    
                    self.updateCurrentPlayer()
                }
            }
        }
    }
}

//----------------------------------
// MARK: Collection View Delegate
//----------------------------------

extension GameplayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.players.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scoreCell", for: indexPath) as! ScoreCell
        
        cell.styleCell(color: game.players[indexPath.row].color)
        cell.scoreLabel.text = String(game.players[indexPath.row].score)
        
        return cell
    }
}
