//
//  PersistanceController.swift
//  Emojis
//
//  Created by Tobias Lewinzon on 22/05/2024.
//

import Foundation
import CoreData

/// Handles CoreData setup, saving, and holds reference to the NSPersistentContainer.
struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Model")

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading persistent store: \(error.localizedDescription)")
            }
        }
        
        // Print Model.sqlite file location for database debugging.
        print("Successfully created container at \(NSPersistentContainer.defaultDirectoryURL()))")
    }
    
    /// Saves the viewContext.
    func saveViewContext() {
        let context = container.viewContext
        
        // Setup merge policy to safely attempt to save new version of the entities:
        //   - Respect constraints.
        //   - The newer (in-memory) version of the entity will trump over the old one.
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        context.saveAndThrow()
    }
    
    /// Returns a background context.
    func getBackgroundContext() -> NSManagedObjectContext {
        let context = PersistenceController.shared.container.newBackgroundContext()
        // Setup merge policy to safely attempt to save new version of the entities:
        //   - Respect constraints.
        //   - The newer (in-memory) version of the entity will trump over the old one.
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
}

extension NSManagedObjectContext {
    /// Calls save() and handles throwing.
    func saveAndThrow() {
        guard hasChanges else { return }
        do {
            try save()
        } catch {
            print("Error saving viewContext: \(error.localizedDescription)")
        }
    }
}
