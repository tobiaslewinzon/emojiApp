//
//  Category.swift
//  Emojis
//
//  Created by Tobias Lewinzon on 22/05/2024.
//

import CoreData

@objc(Category)
class Category: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }
    
    @NSManaged public var name: String
    @NSManaged public var emojis: Set<Emoji>
    
    /// Creates and returns a new instace of Category.
    /// - Parameter context: Pass a context or nil to default to the viewContext.
    static func create(context: NSManagedObjectContext? = nil) -> Category {
        let context = context ?? PersistenceController.shared.container.viewContext
        return Category(context: context)
    }
    
    /// Returns all Categories.
    /// - Parameter context: Pass a context or nil to default to the viewContext.
    static func getAll(context: NSManagedObjectContext? = nil) -> [Category] {
        let context = context ?? PersistenceController.shared.container.viewContext
        
        return context.performAndWait {
            do {
                let fetchResults = try context.fetch(self.fetchRequest())
                // Return result.
                print("Successfully fetched \(fetchResults.count) Categories")
                return fetchResults
                
            } catch let error {
                print("Unable to fetch all Categories: \(error.localizedDescription)")
                return []
            }
        }
    }
}
