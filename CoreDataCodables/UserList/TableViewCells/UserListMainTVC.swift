//
//  UserListMainTVC.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/15/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

class UserListMainTVC: UITableViewCell, Configurable {
    
    var model: UserListViewModelProtocol?

    lazy var userImage: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.borderWidth = 1
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var imgNotes: UIImageView = {
        let imgNotes = UIImageView()
        imgNotes.contentMode = .scaleAspectFit
        imgNotes.clipsToBounds = true
        imgNotes.image = UIImage(named: Constants.kNotesIcon)
        imgNotes.translatesAutoresizingMaskIntoConstraints = false
        return imgNotes
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(userImage)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(imgNotes)
        
        userImage.isSkeletonable = true
        usernameLabel.isSkeletonable = true
        imgNotes.isSkeletonable = true
        
        NSLayoutConstraint.activate([
            userImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            userImage.widthAnchor.constraint(equalToConstant: 70),
            userImage.heightAnchor.constraint(equalToConstant: 70),
            userImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            userImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            
            imgNotes.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            imgNotes.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imgNotes.widthAnchor.constraint(equalToConstant: 40),
            imgNotes.heightAnchor.constraint(equalToConstant: 40),
            
            usernameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
            usernameLabel.trailingAnchor.constraint(equalTo: imgNotes.leadingAnchor, constant: -10),
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 70)
        ])
        self.layoutIfNeeded()
    }
    
    func configure(withModel model: UserListViewModelProtocol) {
        self.model = model
        self.imgNotes.isHidden = model.hideNotes
        self.setImage()
        self.usernameLabel.text = model.profile.login
        
        if model.isSeen == true {
            self.backgroundColor = .lightGray
        } else {
            self.backgroundColor = .white
        }
    }
    
    private func setImage() {
        if let url = model?.profile.avatar_url, let isInverted = model?.isInverted {
            userImage.imageFromServerURL(url, placeHolder:UIImage(named: Constants.kProfilePlaceholder), isInverted: isInverted)
        }
    }
    
    func addShimmerAnimation() {
        usernameLabel.showAnimatedGradientSkeleton()
        userImage.showAnimatedGradientSkeleton()
        imgNotes.showAnimatedGradientSkeleton()
    }
    func hideAnimation() {
        usernameLabel.hideSkeleton(reloadDataAfter: true, transition: .none)
        userImage.hideSkeleton(reloadDataAfter: true, transition: .none)
        imgNotes.hideSkeleton(reloadDataAfter: true, transition: .none)
    }
}
