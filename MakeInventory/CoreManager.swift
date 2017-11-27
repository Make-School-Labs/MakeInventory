//
//  CoreManager.swift
//  MakeInventory
//
//  Created by Eliel A. Gordon on 11/15/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import Foundation
import CoreData

public final class CoreManager {
    
    let name: String
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let momUrl = Bundle.main.url(forResource: name, withExtension: ".momd") else { fatalError("Could not get mom url")}
        
        guard let mom = NSManagedObjectModel(contentsOf: momUrl) else {fatalError("Could not create mom")}
        
        return mom
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        // Setup persistentStore with MOM
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        // Finding SQLite in docs dir
        let fm = FileManager.default
        let docDir = try? fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let storeName = "\(name).sqlite"
        
        let storeUrl = docDir?.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: storeUrl,
                options: [:]
            )
        } catch let error{
            fatalError(error.localizedDescription)
        }
        
        return persistentStoreCoordinator
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = persistentStoreCoordinator
        return moc
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.persistentStoreCoordinator = persistentStoreCoordinator
        return moc
    }()
    
    init(name: String) {
        self.name = name
    }
    
    
}
