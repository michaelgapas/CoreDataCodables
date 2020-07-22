//
//  APIManagerTest.swift
//  CoreDataCodablesTests
//
//  Created by Michael San Diego on 7/8/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

//import CoreData
import XCTest
@testable import CoreDataCodables

class APIManagerTest: XCTestCase {
    
    let apiManager = APIManager.shared
    let coreDataManager = CoreDataManager.shared
    
    func testGetUserList() {
        let context = coreDataManager.backgroundContext
        
        let expectation = self.expectation(description: "User List Expectation")
        
        apiManager.getUserList(since: 0, context: context) { result in
            switch result {
            case .success(let userList):
                XCTAssertNotNil(userList)
                print(userList)
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testGetUserProfile() {
        let context = coreDataManager.backgroundContext
        let testAcceptedName = "wayneeseguin"
        let testErrorName = "adsijioasj"
        
        let expectation = self.expectation(description: "User Profile Expectation")
        
        apiManager.getUserProfile(name: testAcceptedName, context: context) { result in
            switch result {
            case .success(let userProfile):
                XCTAssertNotNil(userProfile)
                print(userProfile)
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
}
