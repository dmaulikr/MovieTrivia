//
//  MDBClientTests.swift
//  MDBClientTests
//
//  Created by Theodore Rothrock on 11/11/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import XCTest
@testable import MovieTrivia

class MDBClientTests: XCTestCase {
    
    var mdbClient: MDBClient!
    
    override func setUp() {
        super.setUp()
        mdbClient = MDBClient()
    }
    
    override func tearDown() {
        mdbClient = nil
        super.tearDown()
    }
    
    func test_searchDatabase_movie_parsesResults() {
        
        let promise = expectation(description: "Call does not produce error message.")
        
        mdbClient.searchDatabase(queryInput: "Jaws", queryType: .movie) { movies, actors, errorMessage in
            
            if let error = errorMessage {
                XCTFail("Received error type: \(error.rawValue)")
                return
            }
            
            promise.fulfill()
            
            guard let movies = movies else {
                XCTFail("MDBClient: Failed to parse search/movies response.")
                return
            }
            
            XCTAssertGreaterThan(movies.count, 0, "MDBClient: Movie array is empty.")
            
            let movie = movies.filter{ $0.title == "Jaws"}.first
            
            guard let jaws = movie else {
                XCTFail("MDBClient: Movies array does not contain expected value.")
                return
            }
            
            XCTAssertEqual(jaws.idNumber, 578, "MDBClient: Movie idNumber does not match expected value.")
            XCTAssertEqual(jaws.releaseDate, "1975-06-18", "MDBClient: Movie releaseDate does not match expected value.")
            XCTAssertEqual(jaws.releaseYear, "1975", "MDBClient: Movie releaseYear does not match expected value.")
            XCTAssertEqual(jaws.posterPath, "/l1yltvzILaZcx2jYvc5sEMkM7Eh.jpg", "MDBClient: Movie posterPath does not match expected value.")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_searchDatabase_person_parsesResults() {
        
        let promise = expectation(description: "Call does not produce error message.")
        
        mdbClient.searchDatabase(queryInput: "Richard Dreyfuss", queryType: .person) { movies, actors, errorMessage in
            
            if let error = errorMessage {
                XCTFail("Received error type: \(error.rawValue)")
                return
            }
            
            promise.fulfill()
            
            guard let actors = actors else {
                XCTFail("MDBClient: Failed to parse search/person response.")
                return
            }
            
            XCTAssertGreaterThan(actors.count, 0, "MDBClient: Actor array is empty.")
            
            let actor = actors.filter{ $0.name == "Richard Dreyfuss"}.first
            
            guard let richardDreyfuss = actor else {
                XCTFail("MDBClient: Actors array does not contain expected results.")
                return
            }

            XCTAssertEqual(richardDreyfuss.idNumber, 3037, "MDBClient: Actor idNumber does not match expected value.")
            XCTAssertEqual(richardDreyfuss.profilePath, "/qJW1IQD4XjzwKfcrP0ESRvDSBar.jpg", "MDBClient: Actor profilePath does not match expected value.")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_getCast_parsesResults() {
        
        let whatAboutBobDict: [String: AnyObject] = [
            "title": "What About Bob?" as AnyObject,
            "id": 10276 as AnyObject
        ]
        
        let whatAboutBob = Movie(dictionary: whatAboutBobDict as [String : AnyObject], context: CoreDataStackManager.sharedInstance.managedObjectContext)
        
        let promise = expectation(description: "Call does not produce error message.")
        
        mdbClient.getCast(movie: whatAboutBob) { castSet, castArray, errorMessage in
            
            if let error = errorMessage {
                XCTFail("Received error type: \(error.rawValue)")
                return
            }
            
            promise.fulfill()
            
            guard let cast = castArray else {
                XCTFail("MDBClient: Failed to parse movie/<id>/credits response.")
                return
            }
            
            XCTAssertGreaterThan(cast.count, 0, "MDBClient: Cast array is empty.")
            
            let actor = cast.filter{ $0.name == "Bill Murray" }.first
            
            guard let billMurray = actor else {
                XCTFail("MDBClient: Cast does not contain expected results.")
                return
            }
            
            XCTAssertEqual(billMurray.idNumber, 1532, "MDBClient: Actor idNumber does not match expected value.")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_getFilmography_parsesResults() {
        
        let billMurrayDict: [String: AnyObject] = [
            "name": "Bill Murray" as AnyObject,
            "id" : 1532 as AnyObject
        ]
        
        let billMurray = Actor(dictionary: billMurrayDict, context: CoreDataStackManager.sharedInstance.managedObjectContext)
        
        let promise = expectation(description: "Call does not produce error message.")
        
        mdbClient.getFilmography(actor: billMurray) { filmography, errorMessage in
            
            if let error = errorMessage {
                XCTFail("Received error type: \(error.rawValue)")
                return
            }
            
            promise.fulfill()
            
            guard let filmography = filmography else {
                XCTFail("MDBClient: Failed to parse person/<id>/movie_credits response.")
                return
            }
            
            XCTAssertGreaterThan(filmography.count, 0, "MDBClient: Filmography set is empty.")
            
            let film = filmography.filter{ $0.title == "Groundhog Day" }.first
            
            guard let groundhogDay = film else {
                XCTFail("MDBClient: Filmography does not contain expected results.")
                return
            }
            
            XCTAssertEqual(groundhogDay.idNumber, 137, "MDBClient: Film idNumber does not match expected value.")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
