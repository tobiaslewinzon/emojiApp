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
    
    @NSManaged public var name: String?
    @NSManaged public var emojis: NSSet?
    
    static func getByName(name: String, context: NSManagedObjectContext? = nil) -> Category? {
        let context = context ?? PersistenceController.shared.container.viewContext
        
        do {
            let request = self.fetchRequest()
            request.predicate = NSPredicate(format: "name == %@", name)
            
            let fetchResults = try context.fetch(request)
            // Return result.
            return fetchResults.first
            
        } catch let error {
            print("Unable to fetch all Categories: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func getOrCreate(name: String, context: NSManagedObjectContext? = nil) -> Category? {
        let context = context ?? PersistenceController.shared.container.viewContext
        
        do {
            let request = self.fetchRequest()
            request.predicate = NSPredicate(format: "name == %@", name)
            
            let fetchResults = try context.fetch(request)
            // Return result.
            return fetchResults.first ?? create(context: context)
            
        } catch let error {
            print("Unable to fetch all Categories: \(error.localizedDescription)")
            return nil
        }
    }
    
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
                return fetchResults
                
            } catch let error {
                print("Unable to fetch all Categories: \(error.localizedDescription)")
                return []
            }
        }
    }
    
    /// Deletes all Categories.
    /// - Parameter context: Pass a context or nil to default to the viewContext.
    static func deleteAll(context: NSManagedObjectContext? = nil) {
        let context = context ?? PersistenceController.shared.container.viewContext
        
        return context.performAndWait {
            do {
                let fetchResults = try context.fetch(self.fetchRequest())
                // Return result.
                fetchResults.forEach { category in
                    context.delete(category)
                }
                
            } catch let error {
                print("Unable to delete all Categories: \(error.localizedDescription)")
            }
        }
    }
}
