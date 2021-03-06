//
//  CoreDataStackManager.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 11/21/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import Foundation
import CoreData

private let SQLITE_FILE_NAME = "MovieTrivia.sqlite"

class CoreDataStackManager {
    
    //--------------------------------------
    // MARK: - Shared Instance
    //--------------------------------------
    
    static let sharedInstance = CoreDataStackManager()
    private init() {}
    
    //--------------------------------------
    // MARK: - Core Data Stack
    //--------------------------------------
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "MovieTrivia", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        let coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(SQLITE_FILE_NAME)
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            print("Failed to log persistent store: \(error)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    //--------------------------------------
    // MARK: - Helper Methods
    //--------------------------------------
    
    func saveContext(completionHandler: (_ error: Error?) -> Void) {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let error = error as Error
                print("Encountered error while saving: \(error.localizedDescription)")
                completionHandler(error)
            }
        }
    }
    
    func clearMoviesAndActors(completionHandler: (_ error: Error?) -> Void) {
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        
        do {
            let list = try managedObjectContext.fetch(fetchRequest) as! [Movie]
            for movie in list {
                managedObjectContext.delete(movie)
            }
        } catch {
            let error = error as Error
            print("Encountered error while clearing Movie cache: \(error.localizedDescription)")
            completionHandler(error)
        }
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Actor")
        
        do {
            let list = try managedObjectContext.fetch(fetchRequest) as! [Actor]
            for actor in list {
                managedObjectContext.delete(actor)
            }
        } catch {
            let error = error as Error
            print("Encountered error while clearing Actor cache: \(error.localizedDescription)")
            completionHandler(error)
        }
    }
    
    func deleteGame(completionHandler: (_ error: Error?) -> Void) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
        
        do {
            let list = try managedObjectContext.fetch(fetchRequest) as! [Game]
            for game in list {
                managedObjectContext.delete(game)
            }
        } catch {
            let error = error as Error
            print("Encountered error: \(error.localizedDescription)")
        }
    }
}
