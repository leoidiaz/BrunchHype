//
//  BrunchSpotController.swift
//  BrunchHype
//
//  Created by Leonardo Diaz on 4/23/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

class BrunchSpotController {

    //MARK: - Single Source
    static let shared = BrunchSpotController()
    
    //MARK: - Fetched Result controller
    
    let fetchedResultsController: NSFetchedResultsController<BrunchSpot>
    
    init() {
        let request: NSFetchRequest<BrunchSpot> = BrunchSpot.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "tier", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        let resultsController: NSFetchedResultsController<BrunchSpot> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "tier", cacheName: nil)
        
        fetchedResultsController = resultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error performing the fetch \(error.localizedDescription)")
        }
    }
    
    //MARK: - CRUD
    func create(brunchSpotWith name: String) {
        BrunchSpot(name: name)
        save()
    }
    func update(brunchSpot: BrunchSpot, name: String, tier: String, summary: String) {
        brunchSpot.name = name
        brunchSpot.tier = tier
        brunchSpot.summary = summary
        save()
    }
    func remove(brunchSpot: BrunchSpot) {
        CoreDataStack.context.delete(brunchSpot)
        save()
    }
    //MARK: - Persistence
    func save() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving Mananged Object Context, item not saved \(error.localizedDescription)")
        }
    }
}// End of Class
