//
//  CoreDataManager.swift
//  AdvancedTodo
//
//  Created by lpiem on 18/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataManagerDelegate {
    func saveData()
    func loadData(query: [NSSortDescriptor]?)
    func deleteItem(item: Item)
    func deleteCategory(category: Category)
}

class CoreDataManager {
    
    static var instance = CoreDataManager()
    
    var items: [Item] = []
    var categories: [Category] = []
    
    private init() {
        self.loadData(query: [NSSortDescriptor(key: "name", ascending: true)])
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "AdvancedTodo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getContext() -> NSManagedObjectContext{
        return self.persistentContainer.viewContext
    }
}

extension CoreDataManager: CoreDataManagerDelegate {
    func deleteItem(item: Item) {
        self.persistentContainer.viewContext.delete(item)
    }
    
    func deleteCategory(category: Category) {
        self.persistentContainer.viewContext.delete(category)
    }
    
    func saveData() {
       self.saveContext()
    }
    
    func loadData(query: [NSSortDescriptor]?) {
        let fetchRequestItem : NSFetchRequest<Item> = NSFetchRequest<Item>(entityName: "Item")
        let fetcheRequestCategory : NSFetchRequest<Category> = NSFetchRequest<Category>(entityName: "Category")
//        let searchQuery = "Coucou"
//        fetcheRequestCategory.predicate = NSPredicate(format: "SUBQUERY(items, $item, $item.name ==[cd] \"\(searchQuery)\").@count > 0")
        
        if (query != nil){
            fetchRequestItem.sortDescriptors = query
            
        }
        
        do{
            let fetchedItemResults = try self.persistentContainer.viewContext.fetch(fetchRequestItem)
            let resultsItem = fetchedItemResults
            self.items = resultsItem
            
            let fetchedCategoryResults = try self.persistentContainer.viewContext.fetch(fetcheRequestCategory)
            let resultsCategory = fetchedCategoryResults
            self.categories = resultsCategory
            
        
        }
        catch {
            print("Could not fetch data")
        }
        
    }
    
    func filterCategories(filter: String = "", sortByItemName: Bool = false, sortByDate: Bool = false) -> NSFetchedResultsController<Item>{
        var sortDescriptor: [NSSortDescriptor] = []
        let fetchRequestItem : NSFetchRequest<Item> = NSFetchRequest<Item>(entityName: "Item")
        
        if(filter != "") {
            fetchRequestItem.predicate = NSPredicate(format: "name CONTAINS [cd] \"\(filter)\"")
        }
        sortDescriptor.append(NSSortDescriptor(key: "category.name", ascending: true))
        
        if(sortByItemName) {
            sortDescriptor.append(NSSortDescriptor(key: "name", ascending: true))
        }
        
        if(sortByDate) {
            sortDescriptor.append(NSSortDescriptor(key: "dateUpdate", ascending: false))
        }
        
        fetchRequestItem.sortDescriptors = sortDescriptor
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequestItem,
                                                                  managedObjectContext: self.persistentContainer.viewContext,
                                                                  sectionNameKeyPath: "category.name", cacheName: nil)
        
        return fetchedResultsController
    }
    
}
       


