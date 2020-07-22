//
//  UserProfileViewModel.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/19/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import Foundation

class UserProfileViewModel {
    
    var coreDataManager = CoreDataManager.shared
    
    var profile: Profile
//    var notes: String?
    
    init(with user: Profile) {
        self.profile = user
    }
    
    var onDataChanged: (() -> Void)?
    var dataUpdated: (() -> Void)?
    var isNotesUpdated: (() -> Void)?
    
    func getName() -> String {
        return profile.name ?? ""
    }
    func getNumOfFollowers() -> String {
        return String(profile.followers)
    }
    func getNumOfFollowing() -> String {
        return String(profile.following)
    }
    
    func getCompany() -> String {
        return profile.company ?? ""
    }
    func getBlog() -> String {
        return profile.blog ?? ""
    }
    
    func getProfileUrl() -> String {
        return profile.avatar_url
    }
    func getNotes() -> String {
        print("notes - ",profile.notes ?? "")
        return profile.notes ?? ""
    }
    
    func saveSeenStatus() {
        coreDataManager.updateSeenStatus(from: profile)
        dataUpdated?()
    }
    
    func saveNotes(notes: String) {
        print("notes - ",notes)
        coreDataManager.updateNotes(with: notes, from: self.profile)
        isNotesUpdated?()
    }
}
