//
//  ReachabilityHandler.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/21/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import Foundation

class ReachabilityHandler: ReachabilityObserverDelegate {
  
    //MARK: Lifecycle
    var hasNetwork: ((Bool) -> Void)?
  
    required init() {
        try? addReachabilityObserver()
    }

    deinit {
        removeReachabilityObserver()
    }

    //MARK: Reachability

    func reachabilityChanged(_ isReachable: Bool) {
        hasNetwork?(isReachable)
        if isReachable {
            print("Network is reachable.")
        } else {
            print("No internet connection.")
        }
    }
}
