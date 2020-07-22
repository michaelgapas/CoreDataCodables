//
//  AppCoordinator.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/11/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var reachability: ReachabilityHandler!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.setupReachabilityHandler()
        
        let vc = UserListViewController()
        let data = DataManager(tblView: vc.tableView)
        vc.data = data
        vc.data.loadData(since: 0)
        vc.data.reloadData = { since in
            vc.data.loadData(since: since)
        }
        vc.data.showProfile = { profile in
            let serialQueue = DispatchQueue(label: "preparing data queue")
            serialQueue.async {
                print("preparing profile. . .")
                vc.data.getUserProfile(profile: profile)
                print("profile updated. . .")
            }
            
            serialQueue.async {
                print("fetching profile. . .")
                let id = Int(profile.id)
                guard let user = vc.data.fetchProfile(with: id) else { return }
                
                DispatchQueue.main.async {
                    self.showProfile(with: user)
                }
            }
        }
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showProfile(with user: Profile) {
        let viewModel = UserProfileViewModel(with: user)
        let vc = UserProfileViewController.instantiate()
        vc.viewModel = viewModel
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension AppCoordinator {
    func setupReachabilityHandler() {
        reachability = ReachabilityHandler()
        reachability.hasNetwork = { isReachable in
            let reachabilityDict = ["hasNetwork": isReachable]
            NotificationCenter.default.post(name: .Reachability, object: nil, userInfo: reachabilityDict)
        }
    }
}
