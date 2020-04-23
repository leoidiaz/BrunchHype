//
//  BrunchSpotController.swift
//  BrunchHype
//
//  Created by Karl Pfister on 4/23/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

class BrunchController {

    static let sharedInstance = BrunchController()
    var fetchedResultsController: NSFetchedResultsController<BrunchSpot>

    /**
     Initalizes an instance of the TaskController class to interact with Task objects using the singleton pattern

     When this class is initalized, an NSFetchedResultsController is initalized to be used with Task objects. The initalized NSFetchedResultsController is assigned to the TaskController's resultsController property, and then the resultsController calls the `performFetch()` method
     */
    init() {
        //creates request
        let request: NSFetchRequest<BrunchSpot> = BrunchSpot.fetchRequest()
        // Add the Sort Descriptors to the request. Sort Descriptors allows us to determine how we want the data organized from the fetch request
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        // Initialize a NSfetchedResultsController using the Fetch Request we just created
        let resultsController: NSFetchedResultsController<BrunchSpot> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "tier", cacheName: nil)
        // Set the initized NSFRC to our property
        fetchedResultsController = resultsController


        do{ // do/catch will display an error if fetchedResultsController isn't working
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error performing the fetch. \(error.localizedDescription)")
        }
    }

    //MARK: - CRUD

    // Create
    /**
     Creates a Task object and calls the `saveToPersistentStore()` method to save it to persistent storage

     - Parameters:
     - name: String value to be passed into the Task initializer's name parameter
     - notes: String value to be passed into the Task initializer's notes parameter
     - due: Date value to be passed into the Task initializer's date parameter
     */
    func add(brunchSpotwith name: String) {
        // Do not need to assign this to a property because the initalizer is marked @discardableResult
        let _ = BrunchSpot(name: name)
        saveToPersistentStore() // defined below
    }

    // Update
    /**
     Updates an existing Task object in persistent storage and and calls the `saveToPersistentStore()` method to save it with the updated values

     - Parameters:
     - task: The Task that needs to be updated
     - name: String value to replace the Task's current name
     - notes: String value to replace the Task's current notes
     - due: Date value to replace the Task's current date
     */
    func update(brunch: BrunchSpot, name: String, tier: String, summary: String) {
        brunch.name = name
        brunch.tier = tier
        brunch.summary = summary
        
        saveToPersistentStore()
    }

    /**
     Toggles a Task object's isComplete boolean value and and calls the `saveToPersistentStore()` method to save it to persistent storage with the updated value

     - Parameters:
     - task: The Task that is being updated
     */
    func changeTier(for brunchSpot: BrunchSpot, with newTier: String) {
        brunchSpot.tier = newTier
        saveToPersistentStore()
    }
    //        func toggleIsCompleteFor(task: Task) {
    //            // Update the isComplete Property on the task to the opposite state
    //            task.isComplete = !task.isComplete
    //            // I want this in the Model Controller because the isComplete is a property on my model.
    //            saveToPersistentStore()
    //        }

    // Delete
    /**
     Removes an existing Task object from the CoreDataStack context by calling the `delete()` method and then saves the context changes by calling `saveToPersistentStore()`

     - Parameters:
     - task: The Task to be removed from storage
     */
    func remove(brunchSpot: BrunchSpot) {
        CoreDataStack.context.delete(brunchSpot)
        saveToPersistentStore()
    }

    /**
     Saves the current CoreDataStack's context to persistent storage by calling the `save()` method
     */
    private func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving Managed Object Context, item not saved")
        }
    }
}

