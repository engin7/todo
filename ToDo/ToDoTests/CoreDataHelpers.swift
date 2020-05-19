//
//  CoreDataHelpers.swift
//  ToDo
//
//  Created by Engin KUK on 19.05.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//


// Created NSManagedObjectContext using in-memory store to create mock objects for testing purpose
// An in-memory store is never persisted to disk, which means you can instantiate the stack and write as much data you want in the test. When the test ends — poof — the in-memory store clears out automatically.

import CoreData
import ToDo

 func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
 
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
     do {
        try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
     } catch {
         print("Adding in-memory persistent store failed")
     }
 
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
     managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
 
     return managedObjectContext
 }


func addMockData() -> [todoItem]? {
    
    let managedObjectContext = setUpInMemoryManagedObjectContext()
    var mockTasks : [todoItem]?
    
     let tasks = [
                  (done: false, name: "Clean house", notes: "Use new detergent."),
                  (done: true, name: "Go to gym", notes: "Monday is leg day!"),
                  ]
           
    for task in tasks {
       let newTasks = NSEntityDescription.insertNewObject(forEntityName: "todoItem", into: managedObjectContext) as! todoItem
       newTasks.done = task.done
       newTasks.name = task.name
       newTasks.notes = task.notes
    }
           
   do {
       try managedObjectContext.save()
   } catch _ {
   }
     
    let fetchRequest = NSFetchRequest<todoItem>(entityName: "todoItem")
    do {
        mockTasks = try managedObjectContext.fetch(fetchRequest)

    } catch _ {}
    
    return mockTasks

}
