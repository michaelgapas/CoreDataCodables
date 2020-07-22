//
//  InvertedCellViewModel.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/17/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

class InvertedCellViewModel: UserListViewModelProtocol {
    
    var profile: Profile
    var isInverted: Bool
    var hideNotes: Bool
    var isSeen: Bool
 
    required init(profile: Profile) {
        self.profile = profile
        self.isInverted = true
        self.hideNotes = true
        self.isSeen = profile.seen
    }
}

extension InvertedCellViewModel: TableViewCompatible {
    var reuseIdentifier: String {
        return "InvertedCellIdentifier"
    }
    
    var getProfile: UserListViewModelProtocol {
        return self
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! UserListMainTVC
    
        cell.configure(withModel: self)
        return cell
    }
}
