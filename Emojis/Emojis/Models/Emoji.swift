//
//  Emoji.swift
//  Emojis
//
//  Created by Tobias Lewinzon on 22/05/2024.
//

import Foundation
import CoreData

@objc(Emoji)
class Emoji: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Emoji> {
        return NSFetchRequest<Emoji>(entityName: "Emoji")
    }
    
    @NSManaged public var name: String
    @NSManaged public var unicode: NSSet
    @NSManaged public var category: Category
    
    /// Creates and returns a new instace of Emoji.
    /// - Parameter context: Pass a context or nil to default to the viewContext.
    static func create(context: NSManagedObjectContext? = nil) -> Emoji {
        let context = context ?? PersistenceController.shared.container.viewContext
        return Emoji(context: context)
    }
    
    /// Returns all Emoji.
    /// - Parameter context: Pass a context or nil to default to the viewContext.
    static func getAll(context: NSManagedObjectContext? = nil) -> [Emoji] {
        let context = context ?? PersistenceController.shared.container.viewContext
        
        return context.performAndWait {
            do {
                let fetchResults = try context.fetch(self.fetchRequest())
                // Return result.
                return fetchResults
                
            } catch let error {
                print("Unable to fetch all Emojis: \(error.localizedDescription)")
                return []
            }
        }
    }
    
    static func getByCategory(category: String, context: NSManagedObjectContext? = nil) -> [Emoji] {
        let context = context ?? PersistenceController.shared.container.viewContext
        
        do {
            let request = self.fetchRequest()
            request.predicate = NSPredicate(format: "category.name == %@", category)
            
            let fetchResults = try context.fetch(request)
            // Return result.
            return fetchResults
            
        } catch let error {
            print("Unable to fetch all Categories: \(error.localizedDescription)")
            return []
        }
    }
}
