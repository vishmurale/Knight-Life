//
//  BlockTableViewCell.swift
//  Glancer
//
//  Created by Cassandra Kane on 11/29/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import UIKit

class BlockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var blockLetter: UILabel!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classTimes: UILabel!
    
    var label: Label? {
        didSet {
            if let label = label, blockLetter = blockLetter, className = className, classTimes = classTimes {
                //sets up note table cell
                self.blockLetter.text = label.blockLetter
                self.className.text = label.className
                self.classTimes.text = label.classTimes
            }
        }
    }

    
}
