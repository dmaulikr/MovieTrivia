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
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableViewHeight.constant = 0
        
//        MDBClient().getCast(movieID: 284052) { (cast, error) in
//            
//            guard error == nil else {
//                // TODO: Handle error.
//                return
//            }
//            
//            guard let cast = cast else {
//                // TODO: Handle error.
//                return
//            }
//            
//            for person in cast {
//                print(person.name)
//            }
//        }
//        
//        MDBClient().getFilmography(personID: 71580) { (movies, error) in
//            
//            guard error == nil else {
//                // TODO: Handle error.
//                return
//            }
//            
//            guard let movies = movies else {
//                // TODO: Handle error.
//                return
//            }
//            
//            for movie in movies {
//                if let releaseYear = movie.releaseYear {
//                    print("\(movie.title) (\(releaseYear))")
//                } else {
//                    print(movie.title)
//                }
//            }
//        }
    }
}

extension GameplayViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.tableViewHeight.constant = 250.0
            self.view.layoutIfNeeded()
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            movies = [Movie]()
            tableView.reloadData()
            return
        }
        
        MDBClient().searchDatabase(queryInput: searchText, queryType: MDBClient.movie) { (movies, error) in
            
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
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as UITableViewCell!
        
        if let releaseYear = movie.releaseYear {
            cell?.textLabel!.text = "\(movie.title) (\(releaseYear))"
        } else {
            cell?.textLabel!.text = movie.title
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
}

