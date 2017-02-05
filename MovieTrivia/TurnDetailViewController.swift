//
//  TurnDetailViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 1/2/17.
//  Copyright © 2017 Theodore Rothrock. All rights reserved.
//

import UIKit

class TurnDetailViewController: UIViewController {
    
    var turn: Turn? = nil
    var cast = [Actor]()
    var isMovieDetail = false
    var filmography = [Movie]()
    
    @IBOutlet weak var firstHeading: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var secondHeading: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set up UI.
        
        self.view.backgroundColor = turn?.player.color
        
        imageview.layer.borderWidth = 2
        imageview.layer.borderColor = UIColor.white.cgColor
        imageview.layer.cornerRadius = 10.0
        imageview.layer.masksToBounds = true
        
        firstHeading.layer.cornerRadius = 10.0
        firstHeading.layer.masksToBounds = true
        firstHeading.textColor = turn?.player.color
        
        secondHeading.layer.cornerRadius = 10.0
        secondHeading.layer.masksToBounds = true
        secondHeading.textColor = turn?.player.color

        if let movie = turn?.movie {
            
            // Show movie details.
            
            isMovieDetail = true
            
            if let releaseYear = movie.releaseYear {
                firstHeading.text = "\(movie.title) (\(releaseYear))"
            } else {
                firstHeading.text = "\(movie.title)"
            }
            
            if let imageData = movie.imageData {
                imageview.image = UIImage(data: imageData)
            } else {
                imageview.image = #imageLiteral(resourceName: "reel")
            }
            
            secondHeading.text = "Cast"
            cast = Array(movie.cast!).sorted { $0.name < $1.name}
            
        } else if let actor = turn?.actor {
            
            // Show actor details.
            
            firstHeading.text = actor.name
            
            if let imageData = actor.imageData {
                imageview.image = UIImage(data: imageData)
            } else {
                imageview.image = #imageLiteral(resourceName: "person")
            }
            
            secondHeading.text = "Filmography"
            filmography = Array(actor.filmography!).sorted { $0.title < $1.title}
        }
        
        let spaceForTable = Int(self.view.frame.height - tableView.frame.minY)
        let numberOfRowsToShow = spaceForTable / 40
        tableViewHeight.constant = CGFloat(numberOfRowsToShow * 40)
        tableView.indicatorStyle = .white
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
    }
}

extension TurnDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isMovieDetail {
            return cast.count
        } else {
            return filmography.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "turnDetailCell", for: indexPath) as! TurnDetailTableViewCell
        
        cell.contentView.backgroundColor = turn?.player.color
        
        if isMovieDetail {
            
            cell.movieLabel.isHidden = true
            cell.activityIndicator.startAnimating()
            
            let actor = cast[indexPath.row]
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
            
        } else {
            
            cell.actorImage.isHidden = true
            cell.actorLabel.isHidden = true
            
            let movie = filmography[indexPath.row]
            if let releaseYear = movie.releaseYear {
                cell.movieLabel.text = "\(movie.title) (\(releaseYear))"
            } else {
                cell.movieLabel.text = "\(movie.title)"
            }
        }
        
        return cell
    }
}
