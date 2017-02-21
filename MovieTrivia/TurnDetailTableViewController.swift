//
//  TurnDetailTableViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 2/6/17.
//  Copyright © 2017 Theodore Rothrock. All rights reserved.
//

import UIKit
import AlamofireImage

class TurnDetailTableViewController: UITableViewController {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    var turn: Turn!
    var cast = [Actor]()
    var isMovieDetail = false
    var filmography = [Movie]()
    var mainTitle = String()
    var secondaryTitle = String()
    var mainImage = UIImage()
    
    //----------------------------------
    // MARK: Lifecyle
    //----------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Turn Details"
        self.view.backgroundColor = turn.player.color
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        if let movie = turn.movie {
            
            // Show movie details.
            
            isMovieDetail = true
            
            if let releaseYear = movie.releaseYear {
                mainTitle = "\(movie.title) (\(releaseYear))"
            } else {
                mainTitle = "\(movie.title)"
            }
            
            if let imageData = movie.imageData {
                if let image = UIImage(data: imageData) {
                    mainImage = image
                } else {
                    mainImage = #imageLiteral(resourceName: "reel")
                }
            } else {
                mainImage = #imageLiteral(resourceName: "reel")
            }

            secondaryTitle = "Cast"
            
            if let cast = movie.cast {
                self.cast = Array(cast).sorted { $0.name < $1.name}
            }
            
        } else if let actor = turn.actor {
            
            // Show actor details.
            
            mainTitle = actor.name
            
            if let imageData = actor.imageData {
                if let image = UIImage(data: imageData) {
                    mainImage = image
                } else {
                    mainImage = #imageLiteral(resourceName: "person")
                }
            } else {
                mainImage = #imageLiteral(resourceName: "person")
            }
            
            secondaryTitle = "Filmography"
            
            if let filmography = actor.filmography {
                self.filmography = Array(filmography).sorted { $0.title < $1.title}
            }
        }
    }

    //----------------------------------
    // MARK: TableView Data Source
    //----------------------------------

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMovieDetail {
            return cast.count + 3
        } else {
            return filmography.count + 3
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            
            // First Header
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
            cell.headerLabel.text = mainTitle
            cell.headerLabel.textColor = turn.player.color
            cell.backgroundColor = turn.player.color
            return cell
            
        } else if indexPath.row == 1 {
            
            // Poster
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "posterCell") as! PosterTableViewCell
            cell.posterImage.image = mainImage
            cell.backgroundColor = turn.player.color
            return cell
            
        } else if indexPath.row == 2 {
            
            // Second Header
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
            cell.headerLabel.text = secondaryTitle
            cell.headerLabel.textColor = turn.player.color
            cell.backgroundColor = turn.player.color
            return cell
            
        } else {
            
            if isMovieDetail {
                
                // Actor Cells
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "actorCell") as! ActorTableViewCell
                cell.backgroundColor = turn.player.color
                cell.actorImage.image = nil
                cell.activityIndicator.startAnimating()
                let actor = cast[indexPath.row - 3]
                cell.actorLabel.text = actor.name
                
                if let imageData = actor.imageData {
                    
                    if let image = UIImage(data: imageData) {
                        cell.activityIndicator.stopAnimating()
                        cell.actorImage.image = image
                    } else {
                        cell.activityIndicator.stopAnimating()
                        cell.actorImage.image = #imageLiteral(resourceName: "person")
                    }
                    
                } else {
                    
                    guard let profilePath = actor.profilePath else {
                        cell.activityIndicator.stopAnimating()
                        cell.actorImage.image = #imageLiteral(resourceName: "person")
                        return cell
                    }
                    
                    guard let imageUrl = URL(string: MDBClient().baseImageURL + ImageSize.small.rawValue + profilePath) else {
                        cell.activityIndicator.stopAnimating()
                        cell.actorImage.image = #imageLiteral(resourceName: "person")
                        return cell
                    }
                    
                    cell.actorImage.af_setImage(withURL: imageUrl)
                }
                
                return cell
                
            } else {
                
                // Movie Cells
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieTableViewCell
                cell.backgroundColor = turn.player.color
                let movie = filmography[indexPath.row - 3]
                if let releaseYear = movie.releaseYear {
                    cell.movieLabel.text = "\(movie.title) (\(releaseYear))"
                } else {
                    cell.movieLabel.text = "\(movie.title)"
                }
                return cell
            }
        }
    }
}
