//
//  NormalCell.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/16/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

class NormalCell: UITableViewCell, Configurable {
    
    var model: NormalCellViewModel?
    
    func configure(withModel model: NormalCellViewModel) {
        self.model = model
    }

}
