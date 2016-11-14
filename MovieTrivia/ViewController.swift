//
//  ViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 11/11/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MDBClient().searchDatabase(queryInput: "Doctor Strange", queryType: MDBClient.movie) { (movies, error) in
            
            guard error == nil else {
                // TODO: Handle error.
                return
            }
            
            guard let movies = movies else {
                // TODO: Handle error.
                return
            }
            
            for movie in movies {
                if let releaseYear = movie.releaseYear {
                    print("\(movie.title) (\(releaseYear))")
                } else {
                    print(movie.title)
                }
            }
        }
        
        MDBClient().getCast(movieID: 284052) { (cast, error) in
            
            guard error == nil else {
                // TODO: Handle error.
                return
            }
            
            guard let cast = cast else {
                // TODO: Handle error.
                return
            }
            
            for person in cast {
                print(person.name)
            }
        }
        
        MDBClient().getFilmography(personID: 71580) { (movies, error) in
            
            guard error == nil else {
                // TODO: Handle error.
                return
            }
            
            guard let movies = movies else {
                // TODO: Handle error.
                return
            }
            
            for movie in movies {
                if let releaseYear = movie.releaseYear {
                    print("\(movie.title) (\(releaseYear))")
                } else {
                    print(movie.title)
                }
            }
        }
    }
}

