//
//  Configurable.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/15/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import Foundation

public protocol Configurable {
    associatedtype T
    var model: T? { get set }
    func configure(withModel model: T)
}
