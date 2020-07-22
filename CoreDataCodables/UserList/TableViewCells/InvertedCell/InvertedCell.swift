//
//  InvertedCell.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/17/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

class InvertedCell: UITableViewCell, Configurable {
    
    var model: InvertedCellViewModel?
    
    func configure(withModel model: InvertedCellViewModel) {
        self.model = model
    }

}
