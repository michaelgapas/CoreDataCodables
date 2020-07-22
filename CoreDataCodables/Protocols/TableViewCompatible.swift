//
//  TableViewCompatible.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/13/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

protocol TableViewCompatible {

    var reuseIdentifier: String { get }
    var getProfile: UserListViewModelProtocol { get }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell
}
