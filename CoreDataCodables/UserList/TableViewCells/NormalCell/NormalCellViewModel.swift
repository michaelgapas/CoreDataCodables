//
//  NormalCellViewModel.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/16/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

class NormalCellViewModel: UserListViewModelProtocol {
    
    var profile: Profile
    var isInverted: Bool
    var hideNotes: Bool
    var isSeen: Bool
 
    required init(profile: Profile) {
        self.profile = profile
        self.isInverted = false
        self.hideNotes = true
        self.isSeen = profile.seen
    }
}

extension NormalCellViewModel: TableViewCompatible {
    var getProfile: UserListViewModelProtocol {
        return self
    }
    
    var reuseIdentifier: String {
        return "NormalCellIdentifier"
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! UserListMainTVC
        cell.configure(withModel: self)
        return cell
    }
}
