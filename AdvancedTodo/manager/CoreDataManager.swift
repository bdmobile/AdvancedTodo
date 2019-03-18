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
}

class CoreDataManager {
    
    static var instance = CoreDataManager()
    
    var items: [Item] = []
    
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
}

extension CoreDataManager: CoreDataManagerDelegate {
    func deleteItem(item: Item) {
        self.persistentContainer.viewContext.delete(item)
    }
    
    func saveData() {
       self.saveContext()
    }
    
    func loadData(query: [NSSortDescriptor]?) {
        let fetchRequest : NSFetchRequest<Item> = NSFetchRequest<Item>(entityName: "Item")
        if (query != nil){
            fetchRequest.sortDescriptors = query
        }
        do{
            let fetchedResults = try self.persistentContainer.viewContext.fetch(fetchRequest)
            let results = fetchedResults
            self.items = results
        }
        catch {
            print("Could not fetch :")
        }
        
    }
    
}
       


