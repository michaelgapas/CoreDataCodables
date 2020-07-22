//
//  UserListViewModelProtocol.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/16/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

protocol UserListViewModelProtocol {
    var profile: Profile { get set }
    var isInverted: Bool { get set }
    var hideNotes: Bool { get set }
    var isSeen: Bool { get set }
    
    init(profile: Profile)
}
