//
//  TableViewManager.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/15/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

class TableViewManager: NSObject, UITableViewDataSource {
    
    public let tableView: UITableView
    var data = [TableViewCompatible]()
    var reloadData: ((Int) -> Void)?
    var showProfile: ((Profile) -> Void)?
    
    var isSearching: Bool = false
    var hasNetwork:Bool = true
    var shouldAnimate = true
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = data[indexPath.row]
        tableView.register(UserListMainTVC.self, forCellReuseIdentifier: model.reuseIdentifier)
        let cell = model.cellForTableView(tableView: tableView, atIndexPath: indexPath) as! UserListMainTVC
        cell.userImage.roundedImage()
        if shouldAnimate == true {
            cell.addShimmerAnimation()
        } else {
            cell.hideAnimation()
        }
        return cell
    }
}

extension TableViewManager: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        headerView.backgroundColor = .yellow

        let lblHeader = UILabel(frame: CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: headerView.frame.size.height))
        lblHeader.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lblHeader.text = "No Internet Connection."
        lblHeader.textAlignment = .center
        headerView.addSubview(lblHeader)
        if hasNetwork == true {
            return nil
        } else {
            return headerView
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if hasNetwork == true {
            return 0
        } else { return 50 }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let model = data[indexPath.row].getProfile
        let profile = model.profile
        self.showProfile?(profile)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            if isSearching == false {
                let model = data[indexPath.row].getProfile
                let userId = Int(model.profile.id)
                
                self.reloadData?(userId)
                
                    let spinner = UIActivityIndicatorView(style: .medium)
                    spinner.startAnimating()
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

                    self.tableView.tableFooterView = spinner
                    self.tableView.tableFooterView?.isHidden = false
            }
        }
    }
}
