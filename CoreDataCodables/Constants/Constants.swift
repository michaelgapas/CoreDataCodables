//
//  Constants.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/18/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import Foundation

struct Constants {
    
    private let userDefaults = UserDefaults.standard
    //MARK: - UserDefaults
    static let isFirstLoaded = "kIsFirstLoaded"
    private let kPageSize = "kPageSize"
    
    //MARK: - imageName
    static let kProfilePlaceholder = "profilePlaceholder"
    static let kNotesIcon = "notesIcon"
    
    func savePageSize(pageSize: Int) {
        userDefaults.setValue(pageSize, forKey: kPageSize)
        userDefaults.synchronize()
    }
    
    func getPageSize() -> Int? {
        if let pageSize = userDefaults.value(forKey: kPageSize) {
            return pageSize as? Int
        }
        return nil
    }
}
