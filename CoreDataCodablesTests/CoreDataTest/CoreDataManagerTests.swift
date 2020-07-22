//
//  CoreDataManagerTests.swift
//  CoreDataCodablesTests
//
//  Created by Michael San Diego on 7/9/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import XCTest
import CoreData
@testable import CoreDataCodables

class CoreDataManagerTests: XCTestCase {

    let apiManager = APIManager.shared
    let coreDataManager = CoreDataManager.shared
    
    func testDeleteData() {
//        let coreDataManager = CoreDataManager.shared
        coreDataManager.deleteAll()
    }
    
    func testDeleteAllData() {
        let expectation = self.expectation(description: "delete all data")
        
        coreDataManager.deleteAll()
        let profile = coreDataManager.fetchAll()
        XCTAssertEqual(profile.count, 0)
        expectation.fulfill()
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchData() {
        let expectation = self.expectation(description: "fetch data")
        
        let profile = coreDataManager.fetchAll()
//        print("object data count - \(profile.count)")
        print(profile.first?.name)
//        print("last object in users -\n\(String(describing: profile.last))")
        let userLast = profile.last
        print("userId - \(String(describing: userLast?.id))")
        
        XCTAssertEqual(profile.count, 0)
        expectation.fulfill()
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testBatchFetch() {
        let expectation = self.expectation(description: "fetch data")
                
        let profile = coreDataManager.batchFetch(from: 0)
        print("object data count - \(profile.count)")
//        print("last object in users -\n\(String(describing: profile.last))")
        let userLast = profile.last
        print("userId - \(String(describing: userLast?.id))")
        
        XCTAssertEqual(profile.count, 30)
        expectation.fulfill()
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testCoreData() {
        let backgroundContext = coreDataManager.backgroundContext
               
        let expectation = self.expectation(description: "User List Expectation")
       
        apiManager.getUserList(since: 46, context: backgroundContext) { result in
            switch result {
            case .success(let userList):
                XCTAssertNotNil(userList)
                self.coreDataManager.saveContext()
           
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let profile = self.coreDataManager.fetchAll()
                    print(profile)
                    XCTAssertEqual(profile.count, 60)
                }
           
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
}
