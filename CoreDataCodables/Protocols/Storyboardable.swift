//
//  Storyboardable.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/20/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

protocol Storyboardable {
    // MARK: - Methods
    static func instantiate() -> Self
}

extension Storyboardable where Self: UIViewController {
    static func instantiate() -> Self {
       // this pulls out "MyApp.MyViewController"
       let id = String(describing: self)
       let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

       // instantiate a view controller with that identifier, and force cast as the type that was requested
       return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
