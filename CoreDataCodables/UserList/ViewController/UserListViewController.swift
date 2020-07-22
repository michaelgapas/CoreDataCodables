//
//  UserListViewController.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/13/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    
    var searchBar = UISearchBar()
    var data: DataManager!
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor   = .white
        tableView.separatorStyle    = .none
        tableView.rowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        setupSearchBar()
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(isUpdateList), name: .UpdateList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isNetworkChanged(_:)), name: .Reachability, object: nil)
    }
    
    @objc func isUpdateList() {
        data.reloadData()
    }
    @objc func isNetworkChanged(_ notification: NSNotification) {
        if let hasNetwork = notification.userInfo?["hasNetwork"] as? Bool {
            data.hasNetwork = hasNetwork
            data.reloadData()
        }
    }
    
    
    func setupSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Search"
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

extension  UserListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "login = '\(searchText)' OR login CONTAINS[cd] '\(searchText)' OR notes = '\(searchText)' OR notes CONTAINS[cd] '\(searchText)'")
            data.search(with: predicate)
        } else {
            data.isSearching = false
            data.reloadData()
        }
    }
}
