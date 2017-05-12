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
    
    func test_searchDatabase_parsesResults() {
        
        let promise = expectation(description: "No error message received.")
        
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
            
            let jawsArray = movies.filter{ $0.title == "Jaws"}
            
            XCTAssertEqual(jawsArray.count, 1, "MDBClient: Multiple instances of the same movie object were created.")
            
            let jaws = jawsArray[0]
            
            XCTAssertEqual(jaws.idNumber, 578, "MDBClient: Movie idNumber does not match expected value.")
            XCTAssertEqual(jaws.releaseDate, "1975-06-18", "MDBClient: Movie releaseDate does not match expected value.")
            XCTAssertEqual(jaws.releaseYear, "1975", "MDBClient: Movie releaseYear does not match expected value.")
            XCTAssertEqual(jaws.posterPath, "/l1yltvzILaZcx2jYvc5sEMkM7Eh.jpg", "MDBClient: Movie posterPath does not match expected value.")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
