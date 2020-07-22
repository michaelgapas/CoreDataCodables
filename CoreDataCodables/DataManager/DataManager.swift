//
//  DataManager.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/11/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit
import CoreData


class DataManager: TableViewManager {
    
    private let coreDataManager = CoreDataManager.shared
    private let apiManager = APIManager.shared
    
    private var profile = [Profile]()
    
    var isLoading: Bool = false
    
    init(tblView: UITableView) {
        super.init(tableView: tblView)
    }
    
    func loadData(since: Int) {
        print("load data since - \(since)")
        isLoading = true
        shouldAnimate = true
        let serialQueue = DispatchQueue(label: "preparing data queue")
        serialQueue.async {
            self.fetchUserList(since: since)
            print("done fetching data.")
        }
        serialQueue.async {
            print("started creating TableViewCompatible from profile. . . ")
            print("current data count - \(self.data.count)")
            let users = self.batchFetch()
            self.profile.append(contentsOf: users)
            self.createViewModels()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.shouldAnimate = false
                self.tableView.reloadData()
            }
            self.isLoading = false
        }
        
        
    }
    
    func reloadData() {
        if isLoading == false {
            shouldAnimate = true
            let serialQueue = DispatchQueue(label: "queue for reloading data")
            serialQueue.async {
                self.profile = [Profile]()
                self.profile = self.fetchAllData()
            }
            serialQueue.async {
                self.createViewModels()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.shouldAnimate = false
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func search(with predicate: NSPredicate) {
        isSearching = true
        let serialQueue = DispatchQueue(label: "queue for searching data")
        serialQueue.async {
            self.profile = [Profile]()
            self.profile = self.searchData(with: predicate)
        }
        serialQueue.async {
            self.createViewModels()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
     
    func createViewModels() {
        var items = [TableViewCompatible]()
        for i in 0..<profile.count {
            let data = profile[i]
            let ind = i + 1
            if ind % 4 == 0 {
                if data.notes == nil || data.notes == "" {
                    //InvertedCell
                    let item = InvertedCellViewModel(profile: data)
                    items.append(item)
                } else {
                    //Notes_InvertedCell
                    let item = InvertedWithNotesCellViewModel(profile: data)
                    items.append(item)
                }
            } else {
                if data.notes == nil || data.notes == "" {
                    //NormalCell
                    let item = NormalCellViewModel(profile: data)
                    items.append(item)
                } else {
                    //Notes_NormalCell
                    let item = NormalWithNotesCellViewModel(profile: data)
                    items.append(item)
                }
            }
        }
        self.data = items
    }
}

extension DataManager {
    //MARK: - Core Data Functions
    func fetchProfile(with id: Int) -> Profile? {
        guard let profile = coreDataManager.fetchUser(id: id) else {
            return nil
        }
        return profile
    }
    
    func fetchAllData() -> [Profile] {
        let profile = coreDataManager.fetchAll()
        print("fetched data count is \(profile.count)")
        return profile
    }
    
    func batchFetch() -> [Profile] {
        let count = data.count
        let profile = coreDataManager.batchFetch(from: count)
        return profile
    }
    
    func deleteAllData() {
        coreDataManager.deleteAll()
        print("deleted all data")
    }
    
    func searchData(with predicate: NSPredicate) -> [Profile] {
        return coreDataManager.search(with: predicate)
    }
    
    //MARK: - API Calls
    func fetchUserList(since: Int) {
        let backgroundContext = coreDataManager.backgroundContext
        let dispatchGroup = DispatchGroup()
        print("started fetching users from API. . . ")
        dispatchGroup.enter()
        apiManager.getUserList(since: since, context: backgroundContext) { (result) in
            switch result {
            case .success(let userList):
                Constants().savePageSize(pageSize: userList.count)
                guard let user = userList.last else { return }
                let id = Int(user.id)
                if self.coreDataManager.checkIfEntityExists(id: id, managedContext: self.coreDataManager.mainContext) == false {
                    self.coreDataManager.saveContext()
                } else { self.coreDataManager.backgroundContext.reset() }
                dispatchGroup.leave()
            case .failure(let error):
                print(error.localizedDescription)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.wait()
    }
    
    func getUserProfile(profile: Profile) {
        let backgroundContext = coreDataManager.backgroundContext
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        let name = profile.login
        apiManager.getUserProfile(name: name, context: backgroundContext) { (result) in
            switch result {
            case .success(let user):
                print("updating profile. . .")
                user.update(with: profile)
                self.coreDataManager.saveContext()
                dispatchGroup.leave()
            case .failure(let error):
                print(error.localizedDescription)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.wait()
    }
}
