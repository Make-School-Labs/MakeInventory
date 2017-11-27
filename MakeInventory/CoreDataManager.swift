//
//  CoreDataManager.swift
//  MakeInventory
//
//  Created by Eliel A. Gordon on 11/15/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.

import Foundation
import CoreData

public final class CoreDataManger {
    
    let name: String
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let momUrl = Bundle.main.url(
            forResource: name,
            withExtension: "momd"
            ) else {fatalError("Can't find MOM model") }
        
        guard let mom = NSManagedObjectModel(contentsOf: momUrl)
            else {fatalError("Can't create MOM")}
        
        return mom
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        // Create PersistentStoreCoordinator with MOM
        // PSC needs mom to know the "schema" of our persistent store
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        // Lets setup a persistent store for our app
        // We are going to use an SQLite Database with our model name
        let fm = FileManager.default
        let storeName = "\(self.name).sqlite"
        
        let documentDir = try? fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let persistentStoreUrl = documentDir?.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: persistentStoreUrl,
                options: [:]
            )
        } catch let error {
            print(error)
        }
        
        return persistentStoreCoordinator
    }()
    
    private(set) lazy var viewContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.name = "View Context"
        moc.persistentStoreCoordinator = persistentStoreCoordinator
        
        return moc
    }()
    
    private(set) lazy var backgroundContext: NSManagedObjectContext = {
       let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.name = "Background Context"
        moc.persistentStoreCoordinator = persistentStoreCoordinator
        
        return moc
    }()
    
    init(name: String) {
        self.name = name
    }
    
    func saveTo(context: NSManagedObjectContext) {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
