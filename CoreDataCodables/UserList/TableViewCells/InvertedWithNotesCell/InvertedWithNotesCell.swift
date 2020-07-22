//
//  InvertedWithNotesCell.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/20/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

class InvertedWithNotesCell: UITableViewCell, Configurable {
    
    var model: InvertedWithNotesCellViewModel?
    
    func configure(withModel model: InvertedWithNotesCellViewModel) {
        self.model = model
    }

}
