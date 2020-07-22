//
//  Coordinator.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/11/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

protocol Coordinator {
    
    var navigationController: UINavigationController { get set }
    func start()
}

