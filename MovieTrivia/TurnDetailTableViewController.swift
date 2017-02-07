//
//  TurnDetailTableViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 2/6/17.
//  Copyright © 2017 Theodore Rothrock. All rights reserved.
//

import UIKit

class TurnDetailTableViewController: UITableViewController {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    var turn: Turn? = nil
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
        
        print("TURN: \(turn)")
        
        self.title = "Turn Details"
        self.view.backgroundColor = turn?.player.color
        
        if let movie = turn?.movie {
            
            // Show movie details.
            
            isMovieDetail = true
            
            if let releaseYear = movie.releaseYear {
                mainTitle = "\(movie.title) (\(releaseYear))"
            } else {
                mainTitle = "\(movie.title)"
            }
            
            if let imageData = movie.imageData {
                mainImage = UIImage(data: imageData)!
            } else {
                mainImage = #imageLiteral(resourceName: "reel")
            }

            secondaryTitle = "Cast"
            cast = Array(movie.cast!).sorted { $0.name < $1.name}
            
        } else if let actor = turn?.actor {
            
            // Show actor details.
            
            mainTitle = actor.name
            
            if let imageData = actor.imageData {
                mainImage = UIImage(data: imageData)!
            } else {
                mainImage = #imageLiteral(resourceName: "person")
            }
            
            secondaryTitle = "Filmography"
            filmography = Array(actor.filmography!).sorted { $0.title < $1.title}
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
            cell.headerLabel.textColor = turn?.player.color
            return cell
            
        } else if indexPath.row == 1 {
            
            // Poster
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "posterCell") as! PosterTableViewCell
            cell.posterImage.image = mainImage
            return cell
            
        } else if indexPath.row == 2 {
            
            // Second Header
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
            cell.headerLabel.text = secondaryTitle
            cell.headerLabel.textColor = turn?.player.color
            return cell
            
        } else {
            
            if isMovieDetail {
                
                // Movie Cells
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieTableViewCell
                let movie = filmography[indexPath.row - 3]
                if let releaseYear = movie.releaseYear {
                    cell.movieLabel.text = "\(movie.title) (\(releaseYear))"
                } else {
                    cell.movieLabel.text = "\(movie.title)"
                }
                return cell
                
            } else {
                
                // Actor Cells
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "actorCell") as! ActorTableViewCell
                cell.activityIndicator.startAnimating()
                let actor = cast[indexPath.row - 3]
                cell.actorLabel.text = actor.name
                MDBClient().getActorImage(actor: actor, size: ImageSize.small) { image, errorMessage in
                    if errorMessage != nil {
                        cell.activityIndicator.stopAnimating()
                        cell.actorImage.image = #imageLiteral(resourceName: "person")
                    } else {
                        cell.activityIndicator.stopAnimating()
                        cell.actorImage.image = image
                    }
                }
                
                return cell
            }
        }
    }
}
