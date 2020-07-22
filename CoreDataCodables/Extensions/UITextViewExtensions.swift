//
//  UITextViewExtensions.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/20/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

extension UITextView {
    func addToolbarAccessory() {
        let toolbarAccessory = ToolbarAccessory()
        toolbarAccessory.didTapDone = {
            self.resignFirstResponder()
        }
        inputAccessoryView = toolbarAccessory
        autocorrectionType = .no
    }
    
    func applyCustomStyle() {
        contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        autocorrectionType = .no
    }
}
