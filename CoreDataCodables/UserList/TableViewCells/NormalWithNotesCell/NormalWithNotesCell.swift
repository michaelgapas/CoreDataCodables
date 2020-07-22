//
//  NormalWithNotesCell.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/20/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

class NormalWithNotesCell: UITableViewCell, Configurable {
    
    var model: NormalWithNotesCellViewModel?
    
    func configure(withModel model: NormalWithNotesCellViewModel) {
        self.model = model
    }

}
