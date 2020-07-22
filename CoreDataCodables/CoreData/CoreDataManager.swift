//
//  CoreDataManager.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/8/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    deinit {
        print("DEALLOCATED: \(self)")
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
       let container = NSPersistentContainer(name: "CoreDataCodables")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        })
        
                container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        //        container.viewContext.undoManager = nil
        //        container.viewContext.shouldDeleteInaccessibleFaults = true
        //
                container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        return context
    }

    lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainContext
        return context
    }()
    
}

extension CoreDataManager {
//    func insert(profile: Profile, context: NSManagedObjectContext) {
//        guard let newProfile = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: context) as? Profile else {
//            print("Error: Failed to create a new object!")
//            return
//        }
//
//        newProfile.avatar_url = profile.avatar_url
//        newProfile.bio = profile.bio
//        newProfile.blog = profile.blog
//        newProfile.company = profile.company
//        newProfile.followers = profile.followers
//        newProfile.following = profile.following
//        newProfile.id = profile.id
//        newProfile.location = profile.location
//        newProfile.login = profile.login
//        newProfile.notes = profile.notes
//        newProfile.name = profile.name
//        newProfile.type = profile.type
//
//        saveContext()
//    }
    
    func saveContext() {
        guard mainContext.hasChanges || backgroundContext.hasChanges else {
            return
        }
        
        backgroundContext.performAndWait {
            do {
                try self.backgroundContext.save()
                mainContext.performAndWait {
                    do {
                        try self.mainContext.save()
                    } catch {
                        fatalError("Error saving main managed object context! \(error)")
                    }
                }
            } catch {
                fatalError("Error saving private managed object context! \(error)")
            }
        }
    }
    
    func updateNotes(with notes: String?, from profile: Profile) {
        guard let note = notes else { return }
        profile.setValue(note, forKey: "notes")
        saveContext()
    }
    
    func updateSeenStatus(from profile: Profile) {
        profile.setValue(true, forKey: "seen")
        saveContext()
    }
    
    func fetchUser(id:Int) -> Profile? {
        let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        var results: [NSManagedObject] = []
        do {
            results = try mainContext.fetch(fetchRequest)
            return results[0] as? Profile
        }
        catch {
            print("error executing fetch request: \(error)")
            return nil
        }
    }
    
    func fetchAll() -> [Profile] {
        let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
        let sort = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let users = try mainContext.fetch(fetchRequest)
            return users
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func batchFetch(from offset: Int) -> [Profile] {
        let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
        let sort = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        if let pageSize = Constants().getPageSize() {
            fetchRequest.fetchOffset = offset
            fetchRequest.fetchLimit = pageSize
        }
        
        do {
            let users = try mainContext.fetch(fetchRequest)
            return users
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
        
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Profile")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try backgroundContext.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print(error.localizedDescription)
        }
        backgroundContext.reset()
    }
    
    func checkIfEntityExists(id: Int, managedContext: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Profile")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)

        var results: [NSManagedObject] = []

        do {
            results = try managedContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.count > 0
    }
    
    func search(with predicate:NSPredicate) -> [Profile] {
        let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
        fetchRequest.predicate = predicate
        do {
            let searchedData = try mainContext.fetch(fetchRequest)
            return searchedData
        } catch {
            print("Could not get search data!")
            return []
        }
    }
}
