//
//  UserProfileViewController.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/20/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit
import SkeletonView

class UserProfileViewController: UIViewController, Storyboardable {

    var viewModel: UserProfileViewModel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var blog: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var txtViewNotes: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var viewNotes: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    private func setupObservables() {
        viewModel.onDataChanged = {
            DispatchQueue.main.async {
//                self.hideAnimation()
                self.view.layoutIfNeeded()
                self.setupData()
            }
        }
        viewModel.isNotesUpdated = {
            NotificationCenter.default.post(name: .UpdateList, object: nil)
            self.showAlert(message: "You have successfully save your notes.")
        }
        viewModel.dataUpdated = {
            NotificationCenter.default.post(name: .UpdateList, object: nil)
        }
    }
    
    private func setupView() {
        setupNavigationBar()
        setupObservables()
        viewModel.saveSeenStatus()
//        addShimmerAnimation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupToolbar()
        
        DispatchQueue.main.async {
//                self.hideAnimation()
            self.view.layoutIfNeeded()
            self.setupData()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = viewModel.getName()
    }
    private func setupData() {
        imgProfile.imageFromServerURL(viewModel.getProfileUrl(), placeHolder:UIImage(named: "profilePlaceholder"), isInverted: false)
        imgProfile.roundedImage()
        
        lblFollowers.text = viewModel.getNumOfFollowers()
        lblFollowing.text = viewModel.getNumOfFollowing()
        
        name.text = viewModel.getName()
        company.text = viewModel.getCompany()
        blog.text = viewModel.getBlog()
        txtViewNotes.text = viewModel.getNotes()
        
        btnSave.layer.cornerRadius = 10
        self.view.layoutIfNeeded()
    }
    
    func addShimmerAnimation() {
        imgProfile.showAnimatedGradientSkeleton()
        lbl1.showAnimatedGradientSkeleton()
        lbl2.showAnimatedGradientSkeleton()
        lbl3.showAnimatedGradientSkeleton()
        lbl4.showAnimatedGradientSkeleton()

        lbl5.showAnimatedGradientSkeleton()
        lblNotes.showAnimatedGradientSkeleton()
        lblFollowers.showAnimatedGradientSkeleton()
        lblFollowing.showAnimatedGradientSkeleton()
        name.showAnimatedGradientSkeleton()
        company.showAnimatedGradientSkeleton()
        blog.showAnimatedGradientSkeleton()

        txtViewNotes.showAnimatedGradientSkeleton()
        btnSave.showAnimatedGradientSkeleton()
        viewNotes.showAnimatedGradientSkeleton()
    }

    func hideAnimation() {
        imgProfile.hideSkeleton()
        lbl1.hideSkeleton()
        lbl2.hideSkeleton()
        lbl3.hideSkeleton()
        lbl4.hideSkeleton()

        lbl5.hideSkeleton()
        lblNotes.hideSkeleton()
        lblFollowers.hideSkeleton()
        lblFollowing.hideSkeleton()
        name.hideSkeleton()
        company.hideSkeleton()
        blog.hideSkeleton()

        txtViewNotes.hideSkeleton()
        btnSave.hideSkeleton()
        viewNotes.hideSkeleton()
    }
    
    func setupToolbar() {
        txtViewNotes.applyCustomStyle()
        txtViewNotes.addToolbarAccessory()
        txtViewNotes.delegate = self
        txtViewNotes.isUserInteractionEnabled = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func didTapSaveNotes(_ sender: Any) {
        txtViewNotes.resignFirstResponder()
        viewModel.saveNotes(notes: txtViewNotes.text)
    }
    
    
}

extension UserProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
//        viewModel.notes = textView.text
    }
}
