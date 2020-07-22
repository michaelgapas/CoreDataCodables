//
//  NormalWithNotesCellViewModel.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/20/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

class NormalWithNotesCellViewModel: UserListViewModelProtocol {
    
    var profile: Profile
    var isInverted: Bool
    var hideNotes: Bool
    var isSeen: Bool
 
    required init(profile: Profile) {
        self.profile = profile
        self.isInverted = false
        self.hideNotes = false
        self.isSeen = profile.seen
    }
}

extension NormalWithNotesCellViewModel: TableViewCompatible {
    var getProfile: UserListViewModelProtocol {
        return self
    }
    
    var reuseIdentifier: String {
        return "NormalWithNotesCellIdentifier"
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! UserListMainTVC
        cell.configure(withModel: self)
        
        return cell
    }
}
