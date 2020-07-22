//
//  ToolbarAccesory.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/20/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

class ToolbarAccessory: UIToolbar {
    
    var didTapDone: (() -> Void)?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        setup()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.barStyle = .default
        self.isTranslucent = true
        self.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        self.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped)),
        ]
        self.sizeToFit()
    }
    
    @objc func doneButtonTapped() {
       didTapDone?()
    }
    
}
