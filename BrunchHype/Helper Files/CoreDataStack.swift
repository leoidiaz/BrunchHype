//
//  CoreDataStack.swift
//  BrunchHype
//
//  Created by Karl Pfister on 4/23/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

    static let container: NSPersistentContainer = {
        // App name is generated from our Bundle
        let appName = Bundle.main.object(forInfoDictionaryKey: (kCFBundleNameKey as String)) as! String
        let container = NSPersistentContainer(name: appName)
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    return container
}()

    static var context: NSManagedObjectContext { return container.viewContext }
}

